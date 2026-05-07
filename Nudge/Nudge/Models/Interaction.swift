import SwiftData
import Foundation

@Model
final class Interaction {
    var id: UUID
    var type: InteractionType
    var notes: String
    var date: Date
    var client: Client?

    init(type: InteractionType, notes: String, date: Date = Date(),
         client: Client? = nil) {
        self.id = UUID()
        self.type = type
        self.notes = notes
        self.date = date
        self.client = client
    }
}
