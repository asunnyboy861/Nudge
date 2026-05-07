import SwiftUI
import SwiftData

struct AddClientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var company = ""
    @State private var notes = ""
    @State private var priority: ClientPriority = .warm
    @State private var source: ClientSource = .manual
    @State private var cadence: FollowUpCadence = .biWeekly

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section("Contact") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    TextField("Company", text: $company)
                        .textContentType(.organizationName)
                }

                Section("Details") {
                    Picker("Priority", selection: $priority) {
                        ForEach(ClientPriority.allCases, id: \.self) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    Picker("Source", selection: $source) {
                        ForEach(ClientSource.allCases, id: \.self) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    Picker("Follow-Up Cadence", selection: $cadence) {
                        ForEach(FollowUpCadence.allCases, id: \.self) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveClient()
                    }
                    .disabled(firstName.isEmpty && lastName.isEmpty)
                    .bold(firstName.isEmpty == false)
                }
            }
        }
    }

    private func saveClient() {
        let client = Client(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            company: company,
            notes: notes,
            priority: priority,
            source: source
        )
        client.followUpCadence = cadence
        modelContext.insert(client)

        let nextDate = Calendar.current.date(byAdding: .day, value: cadence.days, to: Date()) ?? Date()
        client.nextFollowUpAt = nextDate
        let followUp = FollowUp(
            title: "Follow up with \(client.fullName)",
            dueDate: nextDate,
            type: .call,
            client: client
        )
        modelContext.insert(followUp)
        try? modelContext.save()
        dismiss()
    }
}
