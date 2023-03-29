package com.shpak.subscription_checker.billing

import android.content.Context
import android.util.Log
import com.android.billingclient.api.*
import com.shpak.subscription_checker.model.CheckResult
import com.shpak.subscription_checker.model.SubscriptionStatus

class BillingClientWrapper(context: Context) {
    companion object {
        private const val TAG = "BillingClientWrapper"
    }

    private val querySubPurchasesParams = QueryPurchasesParams
        .newBuilder()
        .setProductType(BillingClient.ProductType.SUBS)
        .build()

    private val querySubPurchaseHistoryParams = QueryPurchaseHistoryParams
        .newBuilder()
        .setProductType(BillingClient.ProductType.SUBS)
        .build()

    private var billingClient: BillingClient

    private var isInitialized = false

    init {
        billingClient = BillingClient.newBuilder(context)
            .enablePendingPurchases()
            .setListener { billingResult, purchases ->
                Log.d(TAG, "Purcheses update. Result: $billingResult; Purchases $purchases")
            }
            .build()

        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    isInitialized = true
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

    fun checkSubscription(subscriptionId: List<String>, checkListener: SubscriptionCheckListener) {
        if (!isInitialized) {
            checkListener.onError("Billing client is not initialized")
            return
        }

        billingClient.queryPurchasesAsync(querySubPurchasesParams) { billingResult: BillingResult,
                                                                     purchases: MutableList<Purchase> ->

            Log.d(TAG, "All purchases: $purchases")

            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                val subscriptionOrNull = purchases.find { subscriptionId.containsAll(it.products) }

                if (subscriptionOrNull == null) {
                    findPurchaseInHistory(subscriptionId) { isFound ->
                        checkListener.onCheckResult(
                            CheckResult(
                                subscriptionStatus = if (isFound) SubscriptionStatus.EXPIRED else SubscriptionStatus.NOT_FOUND
                            )
                        )
                    }
                } else {
                    checkListener.onCheckResult(
                        CheckResult(
                            subscriptionStatus = SubscriptionStatus.ACTIVE,
                            purchaseTimeMillis = subscriptionOrNull.purchaseTime
                        )
                    )
                }
            } else {
                checkListener.onError(billingResult.debugMessage)
            }
        }
    }

    private fun findPurchaseInHistory(
        subscriptionId: List<String>,
        isFound: (boolean: Boolean) -> Unit
    ) {
        billingClient.queryPurchaseHistoryAsync(
            querySubPurchaseHistoryParams
        ) { _: BillingResult,
            purchaseHistory: MutableList<PurchaseHistoryRecord>? ->
            if (purchaseHistory == null) {
                isFound(false)
                return@queryPurchaseHistoryAsync
            }

            val purchaseRecordOrNull = purchaseHistory.find {
                subscriptionId.containsAll(it.products)
            }

            Log.d(TAG, "All purchases history: $purchaseHistory")

            isFound(purchaseRecordOrNull != null)
        }
    }
}