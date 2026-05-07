import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }
                .tag(0)

            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "person.2.fill")
                }
                .tag(1)

            FollowUpListView()
                .tabItem {
                    Label("Follow-Ups", systemImage: "bell.badge.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(NudgeColor.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Client.self, FollowUp.self, Interaction.self], inMemory: true)
}
