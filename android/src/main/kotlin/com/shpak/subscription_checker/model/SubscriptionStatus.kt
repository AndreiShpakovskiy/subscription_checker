package com.shpak.subscription_checker.model

enum class SubscriptionStatus(status: String) {
    ACTIVE("active"),
    EXPIRED("expired"),
    NOT_FOUND("not_found")
}