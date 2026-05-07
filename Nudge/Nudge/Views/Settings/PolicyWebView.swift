import SwiftUI

struct PolicyWebView: View {
    let title: String
    let url: String
    @State private var loadedContent: String = "Loading..."

    var body: some View {
        ScrollView {
            Text(loadedContent)
                .font(NudgeFont.body)
                .foregroundStyle(NudgeColor.textPrimary)
                .padding(NudgeSpacing.lg)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadContent()
        }
    }

    private func loadContent() async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let html = String(data: data, encoding: .utf8) {
                loadedContent = html
                    .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "&nbsp;", with: " ")
                    .replacingOccurrences(of: "&amp;", with: "&")
                    .replacingOccurrences(of: "&lt;", with: "<")
                    .replacingOccurrences(of: "&gt;", with: ">")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            loadedContent = "Failed to load content. Please visit \(url) directly."
        }
    }
}
