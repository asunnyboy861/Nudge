import SwiftUI
import SwiftData

struct AddInteractionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let client: Client

    @State private var type: InteractionType = .note
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Type") {
                    Picker("Interaction Type", selection: $type) {
                        ForEach(InteractionType.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Log Interaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveInteraction()
                    }
                    .disabled(notes.isEmpty)
                    .bold(!notes.isEmpty)
                }
            }
        }
    }

    private func saveInteraction() {
        let interaction = Interaction(type: type, notes: notes, client: client)
        modelContext.insert(interaction)
        client.lastContactedAt = Date()
        try? modelContext.save()
        dismiss()
    }
}
