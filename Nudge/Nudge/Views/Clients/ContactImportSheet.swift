import SwiftUI
import SwiftData

struct ContactImportSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var importer = ContactImporter()

    var body: some View {
        NavigationStack {
            VStack(spacing: NudgeSpacing.xl) {
                switch importer.importState {
                case .idle:
                    VStack(spacing: NudgeSpacing.lg) {
                        Image(systemName: "person.2.badge.plus")
                            .font(.system(size: 60))
                            .foregroundStyle(NudgeColor.primary)
                        Text("Import Contacts")
                            .font(NudgeFont.title2)
                            .foregroundStyle(NudgeColor.textPrimary)
                        Text("Import contacts from your iPhone to quickly add clients to Nudge.")
                            .font(NudgeFont.body)
                            .foregroundStyle(NudgeColor.textSecondary)
                            .multilineTextAlignment(.center)
                        Button("Import from Contacts") {
                            Task {
                                await importer.importFromDevice(modelContext: modelContext)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(NudgeColor.primary)
                    }
                    .padding(NudgeSpacing.xl)

                case .importing:
                    VStack(spacing: NudgeSpacing.lg) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Importing contacts...")
                            .font(NudgeFont.headline)
                            .foregroundStyle(NudgeColor.textPrimary)
                    }
                    .padding(NudgeSpacing.xl)

                case .success(let count):
                    VStack(spacing: NudgeSpacing.lg) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(NudgeColor.completed)
                        Text("Import Complete")
                            .font(NudgeFont.title2)
                            .foregroundStyle(NudgeColor.textPrimary)
                        Text("\(count) contact\(count == 1 ? "" : "s") imported successfully")
                            .font(NudgeFont.body)
                            .foregroundStyle(NudgeColor.textSecondary)
                        Button("Done") { dismiss() }
                            .buttonStyle(.borderedProminent)
                            .tint(NudgeColor.primary)
                    }
                    .padding(NudgeSpacing.xl)

                case .failure(let message):
                    VStack(spacing: NudgeSpacing.lg) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(NudgeColor.overdue)
                        Text("Import Failed")
                            .font(NudgeFont.title2)
                            .foregroundStyle(NudgeColor.textPrimary)
                        Text(message)
                            .font(NudgeFont.body)
                            .foregroundStyle(NudgeColor.textSecondary)
                            .multilineTextAlignment(.center)
                        Button("Done") { dismiss() }
                            .buttonStyle(.borderedProminent)
                            .tint(NudgeColor.primary)
                    }
                    .padding(NudgeSpacing.xl)
                }
            }
            .navigationTitle("Import Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
