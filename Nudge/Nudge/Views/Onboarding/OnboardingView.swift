import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var notificationAuthorized = false

    var body: some View {
        TabView(selection: $currentPage) {
            welcomePage.tag(0)
            notificationPage.tag(1)
            importPage.tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private var welcomePage: some View {
        VStack(spacing: NudgeSpacing.xl) {
            Spacer()
            Image(systemName: "hand.point.right.fill")
                .font(.system(size: 80))
                .foregroundStyle(NudgeColor.primary)
            Text("Nudge")
                .font(NudgeFont.largeTitle)
                .foregroundStyle(NudgeColor.textPrimary)
            Text("Never miss a client follow-up again")
                .font(NudgeFont.title3)
                .foregroundStyle(NudgeColor.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Get Started") {
                withAnimation { currentPage = 1 }
            }
            .buttonStyle(.borderedProminent)
            .tint(NudgeColor.primary)
            .padding(.bottom, NudgeSpacing.xxl)
        }
        .padding(NudgeSpacing.xl)
    }

    private var notificationPage: some View {
        VStack(spacing: NudgeSpacing.xl) {
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))
                .foregroundStyle(NudgeColor.primary)
            Text("Stay on Track")
                .font(NudgeFont.title1)
                .foregroundStyle(NudgeColor.textPrimary)
            Text("Allow notifications so Nudge can remind you when it's time to follow up")
                .font(NudgeFont.body)
                .foregroundStyle(NudgeColor.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Allow Notifications") {
                Task {
                    notificationAuthorized = await NotificationManager.shared.requestAuthorization()
                    withAnimation { currentPage = 2 }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(NudgeColor.primary)
            Button("Skip") {
                withAnimation { currentPage = 2 }
            }
            .foregroundStyle(NudgeColor.textSecondary)
            .padding(.bottom, NudgeSpacing.xxl)
        }
        .padding(NudgeSpacing.xl)
    }

    private var importPage: some View {
        VStack(spacing: NudgeSpacing.xl) {
            Spacer()
            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(NudgeColor.primary)
            Text("Import Contacts")
                .font(NudgeFont.title1)
                .foregroundStyle(NudgeColor.textPrimary)
            Text("Import your existing contacts to get started quickly")
                .font(NudgeFont.body)
                .foregroundStyle(NudgeColor.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Start Using Nudge") {
                hasCompletedOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .tint(NudgeColor.primary)
            Button("Skip for Now") {
                hasCompletedOnboarding = true
            }
            .foregroundStyle(NudgeColor.textSecondary)
            .padding(.bottom, NudgeSpacing.xxl)
        }
        .padding(NudgeSpacing.xl)
    }
}
