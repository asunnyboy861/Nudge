import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var purchaseManager = PurchaseManager()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                subscriptionSection
                generalSection
                dataSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
            .task {
                await purchaseManager.loadProducts()
                await purchaseManager.updatePurchasedProducts()
            }
        }
    }

    private var subscriptionSection: some View {
        Section {
            if purchaseManager.isProUser {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("Nudge Pro")
                        .font(NudgeFont.headline)
                    Spacer()
                    Text("Active")
                        .font(NudgeFont.caption)
                        .foregroundStyle(NudgeColor.completed)
                }
            } else {
                Button(action: { showPaywall = true }) {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(NudgeColor.primary)
                        Text("Upgrade to Pro")
                            .font(NudgeFont.headline)
                            .foregroundStyle(NudgeColor.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(NudgeColor.textSecondary)
                    }
                }
            }
        } header: {
            Text("Subscription")
        }
    }

    private var generalSection: some View {
        Section {
            NavigationLink {
                NotificationSettingsView()
            } label: {
                Label("Notifications", systemImage: "bell")
            }

            NavigationLink {
                CadenceSettingsView()
            } label: {
                Label("Default Cadence", systemImage: "clock.arrow.circlepath")
            }
        } header: {
            Text("General")
        }
    }

    private var dataSection: some View {
        Section {
            Button(action: restorePurchases) {
                Label("Restore Purchases", systemImage: "arrow.uturn.down")
            }

            Button(role: .destructive) {
                hasCompletedOnboarding = false
            } label: {
                Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
            }
        } header: {
            Text("Data")
        }
    }

    private var aboutSection: some View {
        Section {
            NavigationLink {
                PolicyWebView(title: "Privacy Policy", url: "https://zzoutuo.github.io/Nudge/privacy.html")
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            NavigationLink {
                PolicyWebView(title: "Terms of Use", url: "https://zzoutuo.github.io/Nudge/terms.html")
            } label: {
                Label("Terms of Use", systemImage: "doc.text")
            }

            NavigationLink {
                PolicyWebView(title: "Support", url: "https://zzoutuo.github.io/Nudge/support.html")
            } label: {
                Label("Support", systemImage: "questionmark.circle")
            }

            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("About")
        }
    }

    private func restorePurchases() {
        Task {
            await purchaseManager.restorePurchases()
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("notificationEnabled") private var notificationEnabled = true
    @AppStorage("reminderHourBefore") private var reminderHourBefore = true
    @AppStorage("reminderDayBefore") private var reminderDayBefore = true
    @AppStorage("badgeEnabled") private var badgeEnabled = true

    var body: some View {
        Form {
            Toggle("Enable Notifications", isOn: $notificationEnabled)
            Toggle("Remind 1 Hour Before", isOn: $reminderHourBefore)
            Toggle("Remind 1 Day Before", isOn: $reminderDayBefore)
            Toggle("Badge Overdue Count", isOn: $badgeEnabled)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CadenceSettingsView: View {
    @AppStorage("defaultCadence") private var defaultCadence = FollowUpCadence.biWeekly.rawValue

    var body: some View {
        Form {
            Picker("Default Follow-Up Cadence", selection: $defaultCadence) {
                ForEach(FollowUpCadence.allCases, id: \.self) { cadence in
                    Text(cadence.rawValue).tag(cadence.rawValue)
                }
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("Default Cadence")
        .navigationBarTitleDisplayMode(.inline)
    }
}
