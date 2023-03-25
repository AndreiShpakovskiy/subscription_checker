package com.shpak.subscription_checker.billing

import com.shpak.subscription_checker.model.CheckResult

interface SubscriptionCheckListener {
    fun onCheckResult(checkResult: CheckResult)
    fun onError(message: String)
}