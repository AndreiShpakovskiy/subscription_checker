class SubscriptionChecker {
    let recieptString: String
    let password: String

    init(recieptString: String, password: String) {
        self.recieptString = recieptString
        self.password = password
        print("SubscriptionChecker constructor invokation")
    }

    func checkSubscription(subscriptionId: [String], onCheckResult: @escaping (CheckResult) -> Void, onError: @escaping (String) -> Void) {
        let requestDict: [String: AnyObject] = [
            "receipt-data" : recieptString as AnyObject,
            "password" : password as AnyObject
        ]

        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDict,
                options: JSONSerialization.WritingOptions.prettyPrinted)

            queryPurchases(requestData, itunesStorePath, onError) { storeResponse in
                // print("Itunes store response: \(storeResponse)")
                if storeResponse.status == StoreResponseStatusCode.ok {
                    processStoreResponse(storeResponse)
                } else if storeResponse.status == StoreResponseStatusCode.wrongEnvironment {
                    self.queryPurchases(requestData, sandboxStorePath, onError) { storeResponse in
                        // print("Sandbox store response: \(storeResponse)")
                        if storeResponse.status == StoreResponseStatusCode.ok {
                            processStoreResponse(storeResponse)
                        } else {
                            unknownStatusError(storeResponse.status)
                        }
                    }
                } else {
                    unknownStatusError(storeResponse.status)
                }
            }
        } catch let queryError {
            print(queryError)
            onError("Query error: \(queryError)")
        }

        func processStoreResponse(_ storeResponse: StoreResponse) {
            let lastPurchase = storeResponse.latestReceiptInfo?.filter { receipt in
                subscriptionId.contains(where: { subId in subId == receipt.productID})
            }.sorted {
                $0.originalPurchaseDateMS < $1.originalPurchaseDateMS
            }.first

            if let lastPurchase = lastPurchase {
                let expirationTimeSeconds = Double(Int(lastPurchase.expiresDateMS) ?? 0) / 1000.0
                let purchaseTimeMillis = Int(lastPurchase.originalPurchaseDateMS)
                let isTrial = Bool(lastPurchase.isTrialPeriod) ?? false

                if isTrial || expirationTimeSeconds > NSDate().timeIntervalSince1970 {
                    onCheckResult(
                        CheckResult(
                            subscriptionStatus: SubscriptionStatus.active,
                            purchaseTimeMillis: purchaseTimeMillis))
                } else {
                     onCheckResult(CheckResult(subscriptionStatus: SubscriptionStatus.expired))
                }
                print("Latest purchase: \(lastPurchase)");
            } else {
               onCheckResult(CheckResult(subscriptionStatus: SubscriptionStatus.notFound))
            }
        }

        func unknownStatusError(_ status: Int) {
            onError("Error: unknown status code: \(status)")
        }
    }

    private func queryPurchases(_ requestData: Data, _ storePath: String,
         _ onError: @escaping (String) -> Void, _ onStoreResponse: @escaping (StoreResponse) -> Void) {

        let storeUrl = URL(string: storePath)!
        var storeRequest = URLRequest(url: storeUrl)
        storeRequest.httpMethod = "POST"
        storeRequest.httpBody = requestData

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: storeRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                onError("API request error")
                return
            }

            guard let data = data else {
                onError("No data received")
                return
            }

            do {
                let response = try JSONDecoder().decode(StoreResponse.self, from: data)
                onStoreResponse(response)
            } catch let parseError {
                onError("Failed to parse store response: \(parseError)")
            }
        })
        task.resume()
    }
}