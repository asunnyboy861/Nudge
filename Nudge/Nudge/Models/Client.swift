import SwiftData
import Foundation

@Model
final class Client {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var company: String
    var notes: String
    var priority: ClientPriority
    var source: ClientSource
    var createdAt: Date
    var lastContactedAt: Date?
    var nextFollowUpAt: Date?
    var followUpCadence: FollowUpCadence
    var tags: [String]
    @Relationship(deleteRule: .cascade, inverse: \FollowUp.client)
    var followUps: [FollowUp] = []
    @Relationship(deleteRule: .cascade, inverse: \Interaction.client)
    var interactions: [Interaction] = []

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var initials: String {
        let first = firstName.prefix(1)
        let last = lastName.prefix(1)
        return "\(first)\(last)".uppercased()
    }

    var isOverdue: Bool {
        guard let next = nextFollowUpAt else { return false }
        return next < Date()
    }

    var daysSinceLastContact: Int? {
        guard let last = lastContactedAt else { return nil }
        return Calendar.current.dateComponents([.day], from: last, to: Date()).day
    }

    init(firstName: String, lastName: String, email: String = "",
         phone: String = "", company: String = "", notes: String = "",
         priority: ClientPriority = .warm, source: ClientSource = .manual) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.company = company
        self.notes = notes
        self.priority = priority
        self.source = source
        self.createdAt = Date()
        self.followUpCadence = .biWeekly
        self.tags = []
    }
}
