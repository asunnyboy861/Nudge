import SwiftUI
import SwiftData

@main
struct NudgeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [Client.self, FollowUp.self, Interaction.self])
    }
}
