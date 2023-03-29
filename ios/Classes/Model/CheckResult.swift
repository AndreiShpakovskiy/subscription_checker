struct CheckResult {
    let subscriptionStatus: SubscriptionStatus
    let purchaseTimeMillis: Int?

    init(subscriptionStatus: SubscriptionStatus, purchaseTimeMillis: Int? = nil) {
        self.subscriptionStatus = subscriptionStatus
        self.purchaseTimeMillis = purchaseTimeMillis
    }

    var asMap: [String: AnyObject] {
        return [
            "subscriptionStatus": subscriptionStatus as AnyObject,
            "purchaseTimeMillis": purchaseTimeMillis as AnyObject
        ]
    }
}