import Foundation

enum ClientPriority: String, Codable, CaseIterable {
    case hot = "Hot"
    case warm = "Warm"
    case cold = "Cold"

    var symbol: String {
        switch self {
        case .hot: return "flame.fill"
        case .warm: return "sun.max.fill"
        case .cold: return "snowflake"
        }
    }

    var color: String {
        switch self {
        case .hot: return "red"
        case .warm: return "orange"
        case .cold: return "blue"
        }
    }
}

enum ClientSource: String, Codable, CaseIterable {
    case manual = "Manual"
    case referral = "Referral"
    case website = "Website"
    case social = "Social Media"
    case cold = "Cold Outreach"
    case networking = "Networking"
}

enum FollowUpCadence: String, Codable, CaseIterable {
    case weekly = "Weekly"
    case biWeekly = "Bi-Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case custom = "Custom"

    var days: Int {
        switch self {
        case .weekly: return 7
        case .biWeekly: return 14
        case .monthly: return 30
        case .quarterly: return 90
        case .custom: return 0
        }
    }
}

enum FollowUpType: String, Codable, CaseIterable {
    case call = "Call"
    case email = "Email"
    case text = "Text"
    case meeting = "Meeting"
    case social = "Social"
    case other = "Other"

    var icon: String {
        switch self {
        case .call: return "phone"
        case .email: return "envelope"
        case .text: return "message"
        case .meeting: return "calendar"
        case .social: return "person.2"
        case .other: return "ellipsis"
        }
    }
}

enum InteractionType: String, Codable, CaseIterable {
    case call = "Call"
    case email = "Email"
    case text = "Text"
    case meeting = "Meeting"
    case note = "Note"
}
