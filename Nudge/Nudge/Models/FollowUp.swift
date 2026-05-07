import SwiftData
import Foundation

@Model
final class FollowUp {
    var id: UUID
    var title: String
    var notes: String
    var dueDate: Date
    var isCompleted: Bool
    var completedAt: Date?
    var type: FollowUpType
    var client: Client?

    init(title: String, notes: String = "", dueDate: Date,
         type: FollowUpType = .call, client: Client? = nil) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = false
        self.type = type
        self.client = client
    }
}
