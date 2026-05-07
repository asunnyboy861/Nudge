import SwiftData
import Observation
import Foundation

@Observable
final class ClientListViewModel {
    var searchText = ""
    var sortOption: SortOption = .nextFollowUp
    var filterPriority: ClientPriority?
    var showOverdueOnly = false
    var filteredClients: [Client] = []

    enum SortOption: String, CaseIterable {
        case nextFollowUp = "Next Follow-Up"
        case name = "Name"
        case lastContact = "Last Contact"
        case priority = "Priority"
        case recentlyAdded = "Recently Added"
    }

    func fetchClients(modelContext: ModelContext) {
        var descriptor = FetchDescriptor<Client>(
            sortBy: [SortDescriptor(\Client.createdAt, order: .reverse)]
        )
        let clients = (try? modelContext.fetch(descriptor)) ?? []
        applyFilters(clients: clients)
    }

    private func applyFilters(clients: [Client]) {
        var result = clients
        if !searchText.isEmpty {
            result = result.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText) ||
                $0.company.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }
        if let priority = filterPriority {
            result = result.filter { $0.priority == priority }
        }
        if showOverdueOnly {
            result = result.filter { $0.isOverdue }
        }
        switch sortOption {
        case .nextFollowUp:
            result.sort { ($0.nextFollowUpAt ?? .distantFuture) < ($1.nextFollowUpAt ?? .distantFuture) }
        case .name:
            result.sort { $0.fullName.localizedCaseInsensitiveCompare($1.fullName) == .orderedAscending }
        case .lastContact:
            result.sort { ($0.lastContactedAt ?? .distantPast) > ($1.lastContactedAt ?? .distantPast) }
        case .priority:
            result.sort { $0.priority.rawValue < $1.priority.rawValue }
        case .recentlyAdded:
            result.sort { $0.createdAt > $1.createdAt }
        }
        filteredClients = result
    }

    func overdueClients() -> [Client] {
        filteredClients.filter { $0.isOverdue }
    }

    func dueTodayClients() -> [Client] {
        filteredClients.filter { client in
            guard let next = client.nextFollowUpAt else { return false }
            return Calendar.current.isDateInToday(next)
        }
    }

    func dueThisWeekClients() -> [Client] {
        filteredClients.filter { client in
            guard let next = client.nextFollowUpAt else { return false }
            return Calendar.current.isDate(next, equalTo: Date(), toGranularity: .weekOfYear)
        }
    }

    func deleteClient(_ client: Client, modelContext: ModelContext) {
        modelContext.delete(client)
        try? modelContext.save()
    }
}
