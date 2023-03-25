import 'package:subscription_checker/model/subscription_status.dart';

class CheckResult {
  CheckResult({required this.subscriptionStatus, this.purchaseTimeMillis});

  final SubscriptionStatus subscriptionStatus;
  final int? purchaseTimeMillis;

  @override
  String toString() {
    return 'CheckResult{subscriptionStatus: $subscriptionStatus, purchaseTimeMillis: $purchaseTimeMillis}';
  }
}
