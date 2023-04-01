# Subscription Checker

This is a simple Flutter plugin to check the status of any Google Play or AppStore subscription.

**Note:** neither Android nor the iOS docs recommends to use client-side purchase verification, so think wisely before using this package.

# Example

To initialize ```SubscriptionChecker``` on iOS you need to provide app-specific [shared secret](https://stackoverflow.com/a/75350186).

```dart
final SubscriptionChecker subscriptionChecker = SubscriptionChecker()
    ..setSharedSecret(PolyglotSettings.iosSharedSecret);
    
final result = await subscriptionChecker.checkSubscription(subscriptionId: ["subscription_id"]);
```
Subscription status can be ```active```, ```expired``` or ```notFound``` in case, if subscription does not appear in purchase history.

**Note**, that [```appStoreReceiptURL```](https://developer.apple.com/documentation/foundation/bundle/1407276-appstorereceipturl) can be ```nil``` in case, when user does not have any active subscriptions, so ```SubscriptionChecker``` will be left uninitialized and ```checkSubscription``` will fail with exception.
