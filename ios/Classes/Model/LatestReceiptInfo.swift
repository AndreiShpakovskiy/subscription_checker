struct LatestReceiptInfo: Codable {
    let quantity: String
    let productID: String
    let transactionID, originalTransactionID, purchaseDate, purchaseDateMS: String
    let purchaseDatePst: String
    let originalPurchaseDate: String
    let originalPurchaseDateMS: String
    let originalPurchaseDatePst: String
    let expiresDate, expiresDateMS, expiresDatePst, webOrderLineItemID: String
    let isTrialPeriod, isInIntroOfferPeriod: String
    let inAppOwnershipType: String
    let subscriptionGroupIdentifier: String?

    enum CodingKeys: String, CodingKey {
        case quantity
        case productID = "product_id"
        case transactionID = "transaction_id"
        case originalTransactionID = "original_transaction_id"
        case purchaseDate = "purchase_date"
        case purchaseDateMS = "purchase_date_ms"
        case purchaseDatePst = "purchase_date_pst"
        case originalPurchaseDate = "original_purchase_date"
        case originalPurchaseDateMS = "original_purchase_date_ms"
        case originalPurchaseDatePst = "original_purchase_date_pst"
        case expiresDate = "expires_date"
        case expiresDateMS = "expires_date_ms"
        case expiresDatePst = "expires_date_pst"
        case webOrderLineItemID = "web_order_line_item_id"
        case isTrialPeriod = "is_trial_period"
        case isInIntroOfferPeriod = "is_in_intro_offer_period"
        case inAppOwnershipType = "in_app_ownership_type"
        case subscriptionGroupIdentifier = "subscription_group_identifier"
    }
}