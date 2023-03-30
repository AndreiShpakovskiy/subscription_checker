import Flutter
import UIKit

public class SubscriptionCheckerPlugin: NSObject, FlutterPlugin {
    
    private var sharedSecret: String? = nil
    private var subscriptionChecker: SubscriptionChecker? = nil
    
    private func getReceipt() -> String? {
        return ReceiptStringRepository.instance.getBase64Receipt()
    }
    
    private func getSubscriptionChecker() -> SubscriptionChecker? {
        if subscriptionChecker != nil {
            return subscriptionChecker
        }
        
        if let receiptString = getReceipt(), let sharedSecret = sharedSecret {
            subscriptionChecker = SubscriptionChecker(recieptString: receiptString, password: sharedSecret)
        }
        
        return subscriptionChecker
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "subscription_checker", binaryMessenger: registrar.messenger())
        let instance = SubscriptionCheckerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        // All currently implemented methods require arguments to be set
        guard let args = args else {
            invalidArgs()
            return
        }
        
        if call.method == "checkSubscription" {
            guard let subscriptionId = args["subscriptionId"] as? [String] else {
                invalidArgs()
                return
            }
            
            if let subscriptionChecker = getSubscriptionChecker() {
                subscriptionChecker.checkSubscription(
                    subscriptionId: subscriptionId,
                    onCheckResult: { (checkResult: CheckResult) in
                        result(checkResult.asMap)
                        print("Result: \(checkResult.asMap)")
                    },
                    onError: { (message: String) in
                        result(FlutterError.init(code: "CHECK_ERROR", message: message, details: nil))
                    }
                )
            } else {
                checkerInitError()
            }
        } else if call.method == "setSharedSecret" {
            guard let sharedSecret = args["sharedSecret"] as? String else {
                invalidArgs()
                return
            }
            
            self.sharedSecret = sharedSecret
        } else {
            result(FlutterMethodNotImplemented)
        }
        
        func invalidArgs() {
            result(FlutterError.init(code: "INVALID_ARGS",
                                     message: "Invalid arguments received: \(call.arguments ?? "nil")", details: nil))
        }
        
        func checkerInitError() {
            var errorDetails =
            "Receipt: \(String(describing: getReceipt())), Password: \(String(describing: sharedSecret))"
            
            if (getReceipt()  == nil) {
                errorDetails = "Receipt data is nil. This can happen, if user has no active subscriptions."
            } else if (sharedSecret == nil) {
                errorDetails = "Shared secret is nil. Make sure you've called setSharedSecret(_) method."
            }
            
            result(FlutterError.init(code: "CHECKER_INIT_ERROR",
                                     message: "Couldn't initialize SubscriptionChecker",
                                     details: errorDetails))
        }
    }
}
