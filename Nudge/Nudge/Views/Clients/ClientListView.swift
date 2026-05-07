import SwiftUI
import SwiftData

struct ClientListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ClientListViewModel()
    @State private var showAddClient = false
    @State private var showImporter = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredClients) { client in
                    NavigationLink(value: client) {
                        ClientCardView(client: client)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: NudgeSpacing.xs, leading: NudgeSpacing.md, bottom: NudgeSpacing.xs, trailing: NudgeSpacing.md))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteClient(client, modelContext: modelContext)
                            viewModel.fetchClients(modelContext: modelContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(NudgeColor.background)
            .navigationTitle("Clients")
            .searchable(text: $viewModel.searchText, prompt: "Search clients...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { showImporter = true }) {
                            Label("Import Contacts", systemImage: "person.2.badge.plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddClient = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Client.self) { client in
                ClientDetailView(client: client)
            }
            .sheet(isPresented: $showAddClient) {
                AddClientView()
            }
            .sheet(isPresented: $showImporter) {
                ContactImportSheet()
            }
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.fetchClients(modelContext: modelContext)
            }
            .onAppear {
                viewModel.fetchClients(modelContext: modelContext)
            }
        }
    }
}

struct ClientCardView: View {
    let client: Client

    var body: some View {
        HStack(spacing: NudgeSpacing.md) {
            Circle()
                .fill(priorityColor)
                .frame(width: 44, height: 44)
                .overlay {
                    Text(client.initials)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(client.fullName)
                    .font(NudgeFont.headline)
                    .foregroundStyle(.primary)
                if !client.company.isEmpty {
                    Text(client.company)
                        .font(NudgeFont.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if client.isOverdue {
                Circle()
                    .fill(NudgeColor.overdue)
                    .frame(width: 10, height: 10)
            } else if let days = client.daysSinceLastContact, days > 14 {
                Text("\(days)d")
                    .font(NudgeFont.caption)
                    .foregroundStyle(NudgeColor.dueToday)
            }
        }
        .padding(NudgeSpacing.md)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var priorityColor: Color {
        switch client.priority {
        case .hot: return NudgeColor.hot
        case .warm: return NudgeColor.warm
        case .cold: return NudgeColor.cold
        }
    }
}
