package com.shpak.subscription_checker.model

data class CheckResult(
    val subscriptionStatus: SubscriptionStatus,
    val purchaseTimeMillis: Long? = null
) {
    val asMap: Map<String, Any?>
        get() = mapOf(
            "subscriptionStatus" to subscriptionStatus,
            "purchaseTimeMillis" to purchaseTimeMillis
        )
}
