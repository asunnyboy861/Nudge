import SwiftData
import Observation
import Foundation

@Observable
final class DashboardViewModel {
    var overdueCount: Int = 0
    var dueTodayCount: Int = 0
    var dueThisWeekCount: Int = 0
    var totalClients: Int = 0
    var activeClients: Int = 0
    var completionRate: Double = 0

    func fetchStats(modelContext: ModelContext) {
        let clientDescriptor = FetchDescriptor<Client>()
        let clients = (try? modelContext.fetch(clientDescriptor)) ?? []
        totalClients = clients.count
        activeClients = clients.filter { $0.lastContactedAt != nil }.count

        let followUpDescriptor = FetchDescriptor<FollowUp>(
            predicate: #Predicate<FollowUp> { !$0.isCompleted }
        )
        let pendingFollowUps = (try? modelContext.fetch(followUpDescriptor)) ?? []

        overdueCount = pendingFollowUps.filter { $0.dueDate < Date() }.count
        dueTodayCount = pendingFollowUps.filter { Calendar.current.isDateInToday($0.dueDate) }.count
        dueThisWeekCount = pendingFollowUps.filter {
            Calendar.current.isDate($0.dueDate, equalTo: Date(), toGranularity: .weekOfYear)
        }.count

        let allDescriptor = FetchDescriptor<FollowUp>()
        let allFollowUps = (try? modelContext.fetch(allDescriptor)) ?? []
        let completedCount = allFollowUps.filter { $0.isCompleted }.count
        completionRate = allFollowUps.isEmpty ? 0 : Double(completedCount) / Double(allFollowUps.count) * 100
    }
}
