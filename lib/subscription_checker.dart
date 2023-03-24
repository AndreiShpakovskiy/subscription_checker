import 'subscription_checker_platform_interface.dart';

class SubscriptionChecker {
  Future<String?> checkSubscription({required List<String> subscriptionId}) {
    return SubscriptionCheckerPlatform.instance
        .checkSubscription(subscriptionId: subscriptionId);
  }
}
