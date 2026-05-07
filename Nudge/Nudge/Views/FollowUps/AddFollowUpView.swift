import SwiftUI
import SwiftData

struct AddFollowUpView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var client: Client?

    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var type: FollowUpType = .call
    @State private var selectedClient: Client?

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    Picker("Type", selection: $type) {
                        ForEach(FollowUpType.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                }

                Section("Schedule") {
                    DatePicker("Due Date", selection: $dueDate, in: Date.now..., displayedComponents: [.date, .hourAndMinute])
                }

                if client == nil {
                    Section("Client") {
                        ClientPickerView(selectedClient: $selectedClient)
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }
            }
            .navigationTitle("New Follow-Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveFollowUp()
                    }
                    .disabled(title.isEmpty)
                    .bold(!title.isEmpty)
                }
            }
            .onAppear {
                selectedClient = client
                if title.isEmpty, let c = client {
                    title = "Follow up with \(c.fullName)"
                }
            }
        }
    }

    private func saveFollowUp() {
        let followUp = FollowUp(
            title: title,
            notes: notes,
            dueDate: dueDate,
            type: type,
            client: selectedClient
        )
        modelContext.insert(followUp)
        if let c = selectedClient {
            c.nextFollowUpAt = dueDate
        }
        try? modelContext.save()
        dismiss()
    }
}

struct ClientPickerView: View {
    @Query(sort: \Client.firstName) private var clients: [Client]
    @Binding var selectedClient: Client?

    var body: some View {
        Picker("Client", selection: $selectedClient) {
            Text("None").tag(nil as Client?)
            ForEach(clients) { client in
                Text(client.fullName).tag(client as Client?)
            }
        }
    }
}
