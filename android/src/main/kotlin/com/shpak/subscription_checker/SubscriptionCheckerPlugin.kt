package com.shpak.subscription_checker

import android.util.Log
import com.shpak.subscription_checker.billing.BillingClientWrapper
import com.shpak.subscription_checker.billing.SubscriptionCheckListener
import com.shpak.subscription_checker.model.CheckResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SubscriptionCheckerPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val TAG = "SubscriptionChecker"
    }

    private lateinit var channel: MethodChannel
    private lateinit var billingClientWrapper: BillingClientWrapper

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "subscription_checker")
        channel.setMethodCallHandler(this)

        billingClientWrapper = BillingClientWrapper(flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "checkSubscription") {

            val args = call.arguments as Map<*, *>
            val subscriptionId = (args["subscriptionId"] as List<*>).map { it as String }

            billingClientWrapper.checkSubscription(
                subscriptionId,
                object : SubscriptionCheckListener {
                    override fun onCheckResult(checkResult: CheckResult) {
                        result.success(checkResult.asMap)
                    }

                    override fun onError(message: String) {
                        result.error("PURCHASE_QUERY_ERROR", message, null)
                    }
                })
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
