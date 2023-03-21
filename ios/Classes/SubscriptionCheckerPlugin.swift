import Flutter
import UIKit

public class SubscriptionCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "subscription_checker", binaryMessenger: registrar.messenger())
    let instance = SubscriptionCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("Not implemented yet")
  }
}
