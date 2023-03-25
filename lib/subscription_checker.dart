import 'package:subscription_checker/model/check_result.dart';

import 'subscription_checker_platform_interface.dart';

class SubscriptionChecker {
  Future<CheckResult> checkSubscription({
    required List<String> subscriptionId,
  }) {
    return SubscriptionCheckerPlatform.instance
        .checkSubscription(subscriptionId: subscriptionId);
  }
}
