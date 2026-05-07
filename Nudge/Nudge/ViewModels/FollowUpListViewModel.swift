import SwiftData
import Observation
import Foundation

@Observable
final class FollowUpListViewModel {
    var searchText = ""
    var filterType: FollowUpType?
    var showCompleted = false

    var overdueFollowUps: [FollowUp] = []
    var dueTodayFollowUps: [FollowUp] = []
    var upcomingFollowUps: [FollowUp] = []
    var completedFollowUps: [FollowUp] = []

    func fetchFollowUps(modelContext: ModelContext) {
        var descriptor = FetchDescriptor<FollowUp>(
            sortBy: [SortDescriptor(\FollowUp.dueDate, order: .forward)]
        )
        let allFollowUps = (try? modelContext.fetch(descriptor)) ?? []

        var filtered = allFollowUps
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.client?.fullName.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        if let type = filterType {
            filtered = filtered.filter { $0.type == type }
        }

        overdueFollowUps = filtered.filter { $0.dueDate < Date() && !$0.isCompleted }
        dueTodayFollowUps = filtered.filter { Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
        upcomingFollowUps = filtered.filter { $0.dueDate > Date() && !Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
        completedFollowUps = filtered.filter { $0.isCompleted }
    }

    func completeFollowUp(_ followUp: FollowUp, modelContext: ModelContext) {
        followUp.isCompleted = true
        followUp.completedAt = Date()
        if let client = followUp.client {
            client.lastContactedAt = Date()
        }
        try? modelContext.save()
    }

    func snoozeFollowUp(_ followUp: FollowUp, modelContext: ModelContext) {
        followUp.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: followUp.dueDate) ?? followUp.dueDate
        try? modelContext.save()
    }

    func deleteFollowUp(_ followUp: FollowUp, modelContext: ModelContext) {
        modelContext.delete(followUp)
        try? modelContext.save()
    }
}
