import 'package:subscription_checker/model/check_result.dart';

import 'subscription_checker_platform_interface.dart';

class SubscriptionChecker {

  Future<void> setSharedSecret(String sharedSecret) {
    return SubscriptionCheckerPlatform.instance
        .setSharedSecret(sharedSecret: sharedSecret);
  }

  Future<CheckResult> checkSubscription({
    required List<String> subscriptionId,
  }) {
    return SubscriptionCheckerPlatform.instance
        .checkSubscription(subscriptionId: subscriptionId);
  }
}
