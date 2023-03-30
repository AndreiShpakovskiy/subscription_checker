class ReceiptStringRepository {
    static let instance = ReceiptStringRepository()
    
    private static let receiptBase64Key = "ReceiptBase64"
    
    private let defaults = UserDefaults.standard
    
    func saveBase64Receipt(_ receiptBase64: String) {
        defaults.set(receiptBase64, forKey: ReceiptStringRepository.receiptBase64Key)
    }
    
    func getBase64Receipt() -> String? {
        if let receiptData = getActualReceiptData() {
            saveBase64Receipt(receiptData)
            return receiptData
        } else {
            return defaults.string(forKey: ReceiptStringRepository.receiptBase64Key)
        }
    }
    
    private func getActualReceiptData() -> String? {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        return receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}
