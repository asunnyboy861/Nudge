import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    let purchaseManager: PurchaseManager
    @State private var selectedProductID: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NudgeSpacing.xl) {
                    headerSection
                    featuresSection
                    planSelection
                    subscribeButton
                    restoreButton
                    termsText
                }
                .padding(NudgeSpacing.lg)
            }
            .background(NudgeColor.background)
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                selectedProductID = PurchaseManager.proYearlyID
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: NudgeSpacing.sm) {
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow)
            Text("Nudge Pro")
                .font(NudgeFont.title1)
                .foregroundStyle(NudgeColor.textPrimary)
            Text("Never miss a follow-up again")
                .font(NudgeFont.body)
                .foregroundStyle(NudgeColor.textSecondary)
        }
    }

    private var featuresSection: some View {
        VStack(spacing: NudgeSpacing.md) {
            featureRow(icon: "person.2.fill", text: "Unlimited clients")
            featureRow(icon: "brain.head.profile.fill", text: "AI follow-up suggestions")
            featureRow(icon: "envelope.badge.fill", text: "AI email drafts")
            featureRow(icon: "icloud.fill", text: "Cloud sync across devices")
            featureRow(icon: "square.grid.2x2.fill", text: "Widgets & Live Activities")
            featureRow(icon: "doc.text.fill", text: "Unlimited email templates")
        }
        .padding(NudgeSpacing.md)
        .background(NudgeColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
    }

    private var planSelection: some View {
        VStack(spacing: NudgeSpacing.sm) {
            ForEach(purchaseManager.products, id: \.id) { product in
                let isSelected = selectedProductID == product.id
                Button(action: { selectedProductID = product.id }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.displayName)
                                .font(NudgeFont.headline)
                                .foregroundStyle(NudgeColor.textPrimary)
                            Text(product.description)
                                .font(NudgeFont.caption)
                                .foregroundStyle(NudgeColor.textSecondary)
                        }
                        Spacer()
                        Text(product.displayPrice)
                            .font(NudgeFont.title3)
                            .foregroundStyle(NudgeColor.primary)
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(isSelected ? NudgeColor.primary : NudgeColor.textSecondary)
                    }
                    .padding(NudgeSpacing.md)
                    .background(isSelected ? NudgeColor.primary.opacity(0.1) : NudgeColor.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: NudgeRadius.md)
                            .stroke(isSelected ? NudgeColor.primary : Color.clear, lineWidth: 2)
                    )
                }
            }
        }
    }

    private var subscribeButton: some View {
        Button(action: subscribe) {
            Text("Subscribe")
                .font(NudgeFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(NudgeSpacing.md)
                .background(NudgeColor.primary)
                .clipShape(RoundedRectangle(cornerRadius: NudgeRadius.md))
        }
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task { await purchaseManager.restorePurchases() }
        }
        .font(NudgeFont.subheadline)
        .foregroundStyle(NudgeColor.primary)
    }

    private var termsText: some View {
        Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
            .font(NudgeFont.footnote)
            .foregroundStyle(NudgeColor.textSecondary)
            .multilineTextAlignment(.center)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: NudgeSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(NudgeColor.primary)
                .frame(width: 24)
            Text(text)
                .font(NudgeFont.body)
                .foregroundStyle(NudgeColor.textPrimary)
            Spacer()
        }
    }

    private func subscribe() {
        guard let productID = selectedProductID,
              let product = purchaseManager.products.first(where: { $0.id == productID }) else { return }
        Task {
            let success = await purchaseManager.purchase(product)
            if success { dismiss() }
        }
    }
}
