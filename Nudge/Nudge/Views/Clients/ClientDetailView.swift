import SwiftUI
import SwiftData

struct ClientDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let client: Client
    @State private var viewModel = ClientDetailViewModel()
    @State private var showAddFollowUp = false
    @State private var showAddInteraction = false

    var body: some View {
        ScrollView {
            VStack(spacing: NudgeSpacing.lg) {
                headerSection
                quickActionsSection
                nextFollowUpSection
                timelineSection
            }
            .padding(NudgeSpacing.md)
        }
        .background(NudgeColor.background)
        .navigationTitle(client.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddInteraction = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddFollowUp) {
            AddFollowUpView(client: client)
        }
        .sheet(isPresented: $showAddInteraction) {
            AddInteractionView(client: client)
        }
    }

    private var headerSection: some View {
        VStack(spacing: NudgeSpacing.sm) {
            Circle()
                .fill(priorityColor)
                .frame(width: 60, height: 60)
                .overlay {
                    Text(client.initials)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            Text(client.fullName)
                .font(NudgeFont.title2)
                .foregroundStyle(NudgeColor.textPrimary)
            if !client.company.isEmpty {
                Text(client.company)
                    .font(NudgeFont.subheadline)
                    .foregroundStyle(NudgeColor.textSecondary)
            }
            if let days = client.daysSinceLastContact {
                Text("Last contact: \(days)d ago")
                    .font(NudgeFont.caption)
                    .foregroundStyle(days > 14 ? NudgeColor.dueToday : NudgeColor.textSecondary)
            } else {
                Text("No contact yet")
                    .font(NudgeFont.caption)
                    .foregroundStyle(NudgeColor.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(NudgeSpacing.lg)
        .background(NudgeColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: NudgeSpacing.sm) {
            Text("Quick Actions")
                .font(NudgeFont.headline)
                .foregroundStyle(NudgeColor.textPrimary)

            HStack(spacing: NudgeSpacing.md) {
                actionButton(icon: "phone.fill", title: "Call", color: NudgeColor.primary) {
                    viewModel.logInteraction(client: client, type: .call, notes: "Phone call", modelContext: modelContext)
                    if let url = URL(string: "tel://\(client.phone)") {
                        UIApplication.shared.open(url)
                    }
                }
                actionButton(icon: "envelope.fill", title: "Email", color: NudgeColor.primary) {
                    viewModel.logInteraction(client: client, type: .email, notes: "Email sent", modelContext: modelContext)
                    if let url = URL(string: "mailto:\(client.email)") {
                        UIApplication.shared.open(url)
                    }
                }
                actionButton(icon: "message.fill", title: "Text", color: NudgeColor.primary) {
                    viewModel.logInteraction(client: client, type: .text, notes: "Text message", modelContext: modelContext)
                    if let url = URL(string: "sms:\(client.phone)") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        .padding(NudgeSpacing.md)
        .background(NudgeColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
    }

    private var nextFollowUpSection: some View {
        Group {
            if let nextFollowUp = client.followUps.filter({ !$0.isCompleted }).sorted(by: { $0.dueDate < $1.dueDate }).first {
                VStack(alignment: .leading, spacing: NudgeSpacing.sm) {
                    Text("Next Follow-Up")
                        .font(NudgeFont.headline)
                        .foregroundStyle(NudgeColor.textPrimary)

                    HStack {
                        Image(systemName: nextFollowUp.type.icon)
                            .foregroundStyle(nextFollowUp.dueDate < Date() ? NudgeColor.overdue : NudgeColor.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(nextFollowUp.title)
                                .font(NudgeFont.body)
                                .foregroundStyle(NudgeColor.textPrimary)
                            Text(nextFollowUp.dueDate, style: .relative)
                                .font(NudgeFont.caption)
                                .foregroundStyle(nextFollowUp.dueDate < Date() ? NudgeColor.overdue : NudgeColor.textSecondary)
                        }
                        Spacer()
                    }

                    HStack(spacing: NudgeSpacing.sm) {
                        Button("Complete") {
                            viewModel.completeFollowUp(nextFollowUp, modelContext: modelContext)
                        }
                        .buttonStyle(.bordered)
                        .tint(NudgeColor.completed)

                        Button("Snooze") {
                            viewModel.snoozeFollowUp(nextFollowUp, modelContext: modelContext)
                        }
                        .buttonStyle(.bordered)
                        .tint(NudgeColor.dueToday)
                    }
                }
                .padding(NudgeSpacing.md)
                .background(NudgeColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
            }
        }
    }

    private var timelineSection: some View {
        Group {
            if !client.interactions.isEmpty {
                VStack(alignment: .leading, spacing: NudgeSpacing.sm) {
                    Text("Timeline")
                        .font(NudgeFont.headline)
                        .foregroundStyle(NudgeColor.textPrimary)

                    ForEach(client.interactions.sorted(by: { $0.date > $1.date })) { interaction in
                        HStack(spacing: NudgeSpacing.md) {
                            Image(systemName: interactionIcon(interaction.type))
                                .foregroundStyle(NudgeColor.primary)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(interaction.type.rawValue)
                                    .font(NudgeFont.body)
                                    .foregroundStyle(NudgeColor.textPrimary)
                                if !interaction.notes.isEmpty {
                                    Text(interaction.notes)
                                        .font(NudgeFont.caption)
                                        .foregroundStyle(NudgeColor.textSecondary)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                            Text(interaction.date, style: .date)
                                .font(NudgeFont.caption)
                                .foregroundStyle(NudgeColor.textSecondary)
                        }
                        .padding(NudgeSpacing.sm)
                    }
                }
                .padding(NudgeSpacing.md)
                .background(NudgeColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
            }
        }
    }

    private func actionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: NudgeSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                Text(title)
                    .font(NudgeFont.caption)
                    .foregroundStyle(NudgeColor.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(NudgeSpacing.md)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
        }
    }

    private var priorityColor: Color {
        switch client.priority {
        case .hot: return NudgeColor.hot
        case .warm: return NudgeColor.warm
        case .cold: return NudgeColor.cold
        }
    }

    private func interactionIcon(_ type: InteractionType) -> String {
        switch type {
        case .call: return "phone"
        case .email: return "envelope"
        case .text: return "message"
        case .meeting: return "calendar"
        case .note: return "note.text"
        }
    }
}
