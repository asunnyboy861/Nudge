import Foundation

struct EmailTemplate: Identifiable, Codable {
    let id: UUID
    var name: String
    var subject: String
    var body: String
    var category: TemplateCategory

    enum TemplateCategory: String, Codable, CaseIterable {
        case followUp = "Follow-Up"
        case checkIn = "Check-In"
        case thankYou = "Thank You"
        case proposal = "Proposal"
        case reminder = "Reminder"
    }

    func render(for client: Client) -> (subject: String, body: String) {
        let renderedSubject = subject
            .replacingOccurrences(of: "{{firstName}}", with: client.firstName)
            .replacingOccurrences(of: "{{lastName}}", with: client.lastName)
            .replacingOccurrences(of: "{{company}}", with: client.company)
            .replacingOccurrences(of: "{{fullName}}", with: client.fullName)
        let renderedBody = body
            .replacingOccurrences(of: "{{firstName}}", with: client.firstName)
            .replacingOccurrences(of: "{{lastName}}", with: client.lastName)
            .replacingOccurrences(of: "{{company}}", with: client.company)
            .replacingOccurrences(of: "{{fullName}}", with: client.fullName)
        return (renderedSubject, renderedBody)
    }

    static let defaults: [EmailTemplate] = [
        EmailTemplate(
            id: UUID(), name: "Quick Follow-Up",
            subject: "Following up - {{company}}",
            body: "Hi {{firstName}},\n\nJust wanted to follow up on our recent conversation. Let me know if you have any questions or if there's anything else I can help with.\n\nBest regards",
            category: .followUp
        ),
        EmailTemplate(
            id: UUID(), name: "Friendly Check-In",
            subject: "Checking in, {{firstName}}!",
            body: "Hey {{firstName}},\n\nIt's been a while since we last connected. Just checking in to see how things are going at {{company}}.\n\nWould love to catch up when you have a moment.",
            category: .checkIn
        ),
        EmailTemplate(
            id: UUID(), name: "Thank You",
            subject: "Thank you, {{firstName}}!",
            body: "Hi {{firstName}},\n\nThank you for your time today. I really enjoyed our conversation about your needs at {{company}}.\n\nI'll follow up with the details we discussed shortly.",
            category: .thankYou
        )
    ]
}
