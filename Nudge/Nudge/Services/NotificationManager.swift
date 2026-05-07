import UserNotifications
import SwiftData
import Foundation

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleFollowUpReminder(for client: Client, followUp: FollowUp) async {
        let content = UNMutableNotificationContent()
        content.title = "Follow-Up Reminder"
        content.body = "Time to \(followUp.type.rawValue.lowercased()) \(client.fullName)"
        content.sound = .default
        content.userInfo = [
            "clientID": client.id.uuidString,
            "followUpID": followUp.id.uuidString,
            "type": "followUp"
        ]
        content.categoryIdentifier = "FOLLOW_UP_CATEGORY"

        let triggerDate = Calendar.current.date(
            byAdding: .hour, value: -1, to: followUp.dueDate
        ) ?? followUp.dueDate

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute], from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: followUp.id.uuidString,
            content: content,
            trigger: trigger
        )
        try? await UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(followUpID: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [followUpID.uuidString])
    }

    func setupNotificationCategories() {
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "Mark Done",
            options: []
        )
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze 1 Day",
            options: []
        )
        let callAction = UNNotificationAction(
            identifier: "CALL_ACTION",
            title: "Call Now",
            options: [.foreground]
        )
        let category = UNNotificationCategory(
            identifier: "FOLLOW_UP_CATEGORY",
            actions: [completeAction, snoozeAction, callAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func updateBadgeCount(modelContext: ModelContext) {
        let now = Date()
        let descriptor = FetchDescriptor<FollowUp>(
            predicate: #Predicate<FollowUp> { !$0.isCompleted && $0.dueDate < now }
        )
        let overdueCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        UNUserNotificationCenter.current().setBadgeCount(overdueCount)
    }
}
