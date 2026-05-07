import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()
    @State private var showClientDetail: Client?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NudgeSpacing.lg) {
                    greetingSection
                    overdueSection
                    dueTodaySection
                    statsSection
                }
                .padding(NudgeSpacing.md)
            }
            .background(NudgeColor.background)
            .navigationTitle("Today")
            .onAppear {
                viewModel.fetchStats(modelContext: modelContext)
            }
            .refreshable {
                viewModel.fetchStats(modelContext: modelContext)
            }
        }
    }

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: NudgeSpacing.xs) {
            Text(greeting)
                .font(NudgeFont.title1)
                .foregroundStyle(NudgeColor.textPrimary)
            if viewModel.overdueCount > 0 {
                Text("\(viewModel.overdueCount) follow-up\(viewModel.overdueCount == 1 ? "" : "s") overdue")
                    .font(NudgeFont.headline)
                    .foregroundStyle(NudgeColor.overdue)
            } else {
                Text("You're all caught up!")
                    .font(NudgeFont.headline)
                    .foregroundStyle(NudgeColor.completed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, NudgeSpacing.sm)
    }

    private var overdueSection: some View {
        Group {
            if viewModel.overdueCount > 0 {
                VStack(alignment: .leading, spacing: NudgeSpacing.sm) {
                    Label("Overdue", systemImage: "exclamationmark.triangle.fill")
                        .font(NudgeFont.headline)
                        .foregroundStyle(NudgeColor.overdue)

                    NavigationLink(value: "overdue") {
                        HStack {
                            Text("\(viewModel.overdueCount) follow-up\(viewModel.overdueCount == 1 ? "" : "s") need attention")
                                .font(NudgeFont.body)
                                .foregroundStyle(NudgeColor.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(NudgeColor.textSecondary)
                        }
                        .padding(NudgeSpacing.md)
                        .background(NudgeColor.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
                    }
                }
            }
        }
    }

    private var dueTodaySection: some View {
        Group {
            if viewModel.dueTodayCount > 0 {
                VStack(alignment: .leading, spacing: NudgeSpacing.sm) {
                    Label("Due Today", systemImage: "clock.fill")
                        .font(NudgeFont.headline)
                        .foregroundStyle(NudgeColor.dueToday)

                    HStack {
                        Text("\(viewModel.dueTodayCount) follow-up\(viewModel.dueTodayCount == 1 ? "" : "s") scheduled today")
                            .font(NudgeFont.body)
                            .foregroundStyle(NudgeColor.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(NudgeColor.textSecondary)
                    }
                    .padding(NudgeSpacing.md)
                    .background(NudgeColor.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
                }
            }
        }
    }

    private var statsSection: some View {
        HStack(spacing: NudgeSpacing.md) {
            DashboardStatView(title: "Clients", value: "\(viewModel.totalClients)", icon: "person.2.fill", color: NudgeColor.primary)
            DashboardStatView(title: "Active", value: "\(viewModel.activeClients)", icon: "bolt.fill", color: NudgeColor.completed)
            DashboardStatView(title: "This Week", value: "\(viewModel.dueThisWeekCount)", icon: "calendar", color: NudgeColor.dueToday)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

struct DashboardStatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: NudgeSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(NudgeFont.title2)
                .foregroundStyle(NudgeColor.textPrimary)
            Text(title)
                .font(NudgeFont.caption)
                .foregroundStyle(NudgeColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(NudgeSpacing.md)
        .background(NudgeColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}
