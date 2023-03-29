import Flutter
import UIKit

public class SubscriptionCheckerPlugin: NSObject, FlutterPlugin {

    let sandboxStorePath = "https://sandbox.itunes.apple.com/verifyReceipt"
    let itunesStorePath = "https://buy.itunes.apple.com/verifyReceipt"

    let subscriptionChecker: SubscriptionChecker = {
        return SubscriptionChecker(recieptString: "", password: "")
    }()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "subscription_checker", binaryMessenger: registrar.messenger())
        let instance = SubscriptionCheckerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "checkSubscription" {
            if let args = call.arguments as? Dictionary<String, Any>,
                guard let number = args["subscriptionId"] as? String else { return }

                subscriptionChecker.checkSubscription(
                    subscriptionId: number,
                    onCheckResult: { (result: CheckResult) in
                        print("Result: \(result.asMap)")
                    },
                    onError: { (message: String) in
                        print("Error: \(message)")
                    }
                )

                // result(/* return result */)
            } else {
                result(FlutterError.init(code: "Invalid arguments received", message: nil, details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
