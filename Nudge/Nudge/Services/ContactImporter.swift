import Contacts
import SwiftData
import Observation

@Observable
final class ContactImporter {
    var importState: ImportState = .idle
    var importedCount: Int = 0

    enum ImportState {
        case idle
        case importing
        case success(Int)
        case failure(String)
    }

    func importFromDevice(modelContext: ModelContext) async {
        await MainActor.run { importState = .importing }

        let store = CNContactStore()
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor
        ]

        do {
            let granted = try await store.requestAccess(for: .contacts)
            guard granted else {
                await MainActor.run { importState = .failure("Contact access denied") }
                return
            }

            let request = CNContactFetchRequest(keysToFetch: keys)
            var count = 0
            let existingEmails = fetchExistingEmails(modelContext: modelContext)

            try store.enumerateContacts(with: request) { contact, _ in
                let email = contact.emailAddresses.first?.value as String? ?? ""
                let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                guard !email.isEmpty || !phone.isEmpty else { return }
                guard !existingEmails.contains(email.lowercased()) else { return }

                let client = Client(
                    firstName: contact.givenName,
                    lastName: contact.familyName,
                    email: email,
                    phone: phone,
                    company: contact.organizationName,
                    source: .manual
                )
                modelContext.insert(client)
                count += 1
            }
            try modelContext.save()
            await MainActor.run {
                importedCount = count
                importState = .success(count)
            }
        } catch {
            await MainActor.run { importState = .failure(error.localizedDescription) }
        }
    }

    private func fetchExistingEmails(modelContext: ModelContext) -> Set<String> {
        let descriptor = FetchDescriptor<Client>()
        let clients = (try? modelContext.fetch(descriptor)) ?? []
        return Set(clients.map { $0.email.lowercased() }.filter { !$0.isEmpty })
    }
}
