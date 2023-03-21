package com.shpak.subscription_checker

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.android.billingclient.api.*
import com.android.billingclient.api.BillingClient.BillingResponseCode

class SubscriptionCheckerPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val TAG = "SubscriptionChecker"
    }

    private lateinit var channel: MethodChannel
    private lateinit var billingClient: BillingClient
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "subscription_checker")
        channel.setMethodCallHandler(this)

        billingClient = BillingClient.newBuilder(context)
            .enablePendingPurchases()
            .setListener(PurchasesUpdatedListener { billingResult, purchases ->
                Log.d(TAG, "Purcheses update: result $billingResult, purchases $purchases")
            })
            .build()

        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    Log.d(TAG, "The BillingClient is ready")
                }
            }

            override fun onBillingServiceDisconnected() {
                Log.e(
                    TAG, "The BillingClient is disconnected, "
                            + "ensure your device supports Google Play Services"
                )
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "checkSubscription") {
//            billingClient.queryPurchaseHistoryAsync(BillingClient.ProductType.SUBS) { responseCode, purchasesList ->
//                Log.d(
//                    "TAG123",
//                    ">>> Full purchase history: $responseCode, $purchasesList"
//                )
//            }

//                        val params = QueryPurchasesParams.newBuilder()
//                            .setProductType(ProductType.SUBS)
//
//                        val purchasesResult = billingClient.queryPurchasesAsync(params.build())

            val queryPurchasesParams = QueryPurchasesParams
                .newBuilder()
                .setProductType(BillingClient.ProductType.SUBS)
                .build()

            billingClient.queryPurchasesAsync(queryPurchasesParams) { billingResult: BillingResult,
                                                                      purchases: MutableList<Purchase> ->

                if (billingResult.responseCode == BillingResponseCode.OK) {
                    Log.d(
                        TAG,
                        "QueryPurchasesResponse: ${purchases.first().purchaseTime}; ${billingResult.debugMessage}"
                    )
                } else {
                    result.error(
                        "$billingResult",
                        "Error while quering purchases",
                        billingResult.debugMessage
                    )
                }
            }

            // result.success("Not implemented yet")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}