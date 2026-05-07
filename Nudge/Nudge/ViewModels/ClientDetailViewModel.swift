import SwiftData
import Observation
import Foundation

@Observable
final class ClientDetailViewModel {
    var showActionSheet = false
    var showAddFollowUp = false
    var showAddInteraction = false

    func logInteraction(client: Client, type: InteractionType, notes: String, modelContext: ModelContext) {
        let interaction = Interaction(type: type, notes: notes, client: client)
        modelContext.insert(interaction)
        client.lastContactedAt = Date()
        scheduleNextFollowUp(client: client, modelContext: modelContext)
        try? modelContext.save()
    }

    func completeFollowUp(_ followUp: FollowUp, modelContext: ModelContext) {
        followUp.isCompleted = true
        followUp.completedAt = Date()
        if let client = followUp.client {
            client.lastContactedAt = Date()
            scheduleNextFollowUp(client: client, modelContext: modelContext)
        }
        try? modelContext.save()
    }

    func snoozeFollowUp(_ followUp: FollowUp, modelContext: ModelContext) {
        followUp.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: followUp.dueDate) ?? followUp.dueDate
        try? modelContext.save()
    }

    private func scheduleNextFollowUp(client: Client, modelContext: ModelContext) {
        let cadence = client.followUpCadence
        guard cadence != .custom, cadence.days > 0 else { return }
        let nextDate = Calendar.current.date(
            byAdding: .day, value: cadence.days,
            to: Date()
        ) ?? Date()
        client.nextFollowUpAt = nextDate
        let followUp = FollowUp(
            title: "Follow up with \(client.fullName)",
            dueDate: nextDate,
            type: .call,
            client: client
        )
        modelContext.insert(followUp)
    }
}
