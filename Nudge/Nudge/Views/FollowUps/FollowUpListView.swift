import SwiftUI
import SwiftData

struct FollowUpListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FollowUpListViewModel()
    @State private var showAddFollowUp = false

    var body: some View {
        NavigationStack {
            List {
                if !viewModel.overdueFollowUps.isEmpty {
                    Section {
                        ForEach(viewModel.overdueFollowUps) { followUp in
                            FollowUpRowView(followUp: followUp, isOverdue: true)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteFollowUp(followUp, modelContext: modelContext)
                                        viewModel.fetchFollowUps(modelContext: modelContext)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.completeFollowUp(followUp, modelContext: modelContext)
                                        viewModel.fetchFollowUps(modelContext: modelContext)
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }
                                    .tint(NudgeColor.completed)
                                }
                        }
                    } header: {
                        Label("Overdue (\(viewModel.overdueFollowUps.count))", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(NudgeColor.overdue)
                    }
                }

                if !viewModel.dueTodayFollowUps.isEmpty {
                    Section {
                        ForEach(viewModel.dueTodayFollowUps) { followUp in
                            FollowUpRowView(followUp: followUp, isOverdue: false)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.completeFollowUp(followUp, modelContext: modelContext)
                                        viewModel.fetchFollowUps(modelContext: modelContext)
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }
                                    .tint(NudgeColor.completed)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        viewModel.snoozeFollowUp(followUp, modelContext: modelContext)
                                        viewModel.fetchFollowUps(modelContext: modelContext)
                                    } label: {
                                        Label("Snooze", systemImage: "clock")
                                    }
                                    .tint(NudgeColor.dueToday)
                                }
                        }
                    } header: {
                        Label("Due Today (\(viewModel.dueTodayFollowUps.count))", systemImage: "clock.fill")
                            .foregroundStyle(NudgeColor.dueToday)
                    }
                }

                if !viewModel.upcomingFollowUps.isEmpty {
                    Section {
                        ForEach(viewModel.upcomingFollowUps) { followUp in
                            FollowUpRowView(followUp: followUp, isOverdue: false)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        viewModel.completeFollowUp(followUp, modelContext: modelContext)
                                        viewModel.fetchFollowUps(modelContext: modelContext)
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }
                                    .tint(NudgeColor.completed)
                                }
                        }
                    } header: {
                        Label("Upcoming (\(viewModel.upcomingFollowUps.count))", systemImage: "calendar")
                    }
                }

                if viewModel.showCompleted && !viewModel.completedFollowUps.isEmpty {
                    Section {
                        ForEach(viewModel.completedFollowUps) { followUp in
                            FollowUpRowView(followUp: followUp, isOverdue: false)
                                .opacity(0.6)
                        }
                    } header: {
                        Label("Completed (\(viewModel.completedFollowUps.count))", systemImage: "checkmark.circle.fill")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(NudgeColor.background)
            .navigationTitle("Follow-Ups")
            .searchable(text: $viewModel.searchText, prompt: "Search follow-ups...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddFollowUp = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddFollowUp) {
                AddFollowUpView()
            }
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.fetchFollowUps(modelContext: modelContext)
            }
            .onAppear {
                viewModel.fetchFollowUps(modelContext: modelContext)
            }
        }
    }
}

struct FollowUpRowView: View {
    let followUp: FollowUp
    let isOverdue: Bool

    private var isDueToday: Bool {
        Calendar.current.isDateInToday(followUp.dueDate)
    }

    var body: some View {
        HStack(spacing: NudgeSpacing.md) {
            Image(systemName: followUp.type.icon)
                .font(.system(size: 20))
                .foregroundStyle(isOverdue ? NudgeColor.overdue : isDueToday ? NudgeColor.dueToday : NudgeColor.primary)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(followUp.title)
                    .font(NudgeFont.headline)
                    .foregroundStyle(.primary)
                    .strikethrough(followUp.isCompleted)
                if let name = followUp.client?.fullName {
                    Text(name)
                        .font(NudgeFont.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(followUp.dueDate, style: .relative)
                    .font(NudgeFont.caption)
                    .foregroundStyle(isOverdue ? NudgeColor.overdue : .secondary)
            }

            Spacer()

            if !followUp.isCompleted {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(NudgeColor.textSecondary)
            }
        }
        .padding(NudgeSpacing.sm)
    }
}
