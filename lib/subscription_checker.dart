import 'subscription_checker_platform_interface.dart';

class SubscriptionChecker {
  Future<String?> checkSubscription({required Set<String> subscriptionIds}) {
    return SubscriptionCheckerPlatform.instance.checkSubscription();
  }
}
