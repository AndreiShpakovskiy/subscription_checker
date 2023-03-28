struct StoreResponse: Codable {
    // Unused properties are not listed here
    let latestReceiptInfo: [LatestReceiptInfo]?
    let status: Int

    enum CodingKeys: String, CodingKey {
        case latestReceiptInfo = "latest_receipt_info"
        case status
    }
}