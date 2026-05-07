import StoreKit
import Observation
import Foundation

@Observable
final class PurchaseManager {
    var purchasedProductIDs: Set<String> = []
    var products: [Product] = []
    var isLoading = false

    static let proMonthlyID = "com.zzoutuo.Nudge.proMonthly"
    static let proYearlyID = "com.zzoutuo.Nudge.proYearly"
    static let businessMonthlyID = "com.zzoutuo.Nudge.businessMonthly"
    static let businessYearlyID = "com.zzoutuo.Nudge.businessYearly"

    var isProUser: Bool {
        purchasedProductIDs.contains(Self.proMonthlyID) ||
        purchasedProductIDs.contains(Self.proYearlyID) ||
        purchasedProductIDs.contains(Self.businessMonthlyID) ||
        purchasedProductIDs.contains(Self.businessYearlyID)
    }

    var isBusinessUser: Bool {
        purchasedProductIDs.contains(Self.businessMonthlyID) ||
        purchasedProductIDs.contains(Self.businessYearlyID)
    }

    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: [
                Self.proMonthlyID, Self.proYearlyID,
                Self.businessMonthlyID, Self.businessYearlyID
            ])
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {}
        isLoading = false
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    purchasedProductIDs.insert(transaction.productID)
                    await transaction.finish()
                    return true
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {}
        return false
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {}
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }
}
