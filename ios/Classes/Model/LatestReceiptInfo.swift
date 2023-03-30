struct LatestReceiptInfo: Codable {
    // Unused properties are not listed here
    let productID: String
    let purchaseDateMS: String
    let expiresDateMS: String
    let isTrialPeriod: String

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case purchaseDateMS = "purchase_date_ms"
        case expiresDateMS = "expires_date_ms"
        case isTrialPeriod = "is_trial_period"
    }
}
