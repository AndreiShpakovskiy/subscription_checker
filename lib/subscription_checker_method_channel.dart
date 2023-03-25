import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:subscription_checker/model/check_result.dart';
import 'package:subscription_checker/model/subscription_status.dart';
import 'subscription_checker_platform_interface.dart';

class MethodChannelSubscriptionChecker extends SubscriptionCheckerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('subscription_checker');

  @override
  Future<CheckResult> checkSubscription({
    required List<String> subscriptionId,
  }) async {
    final resultMap = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'checkSubscription',
      {"subscriptionId": subscriptionId},
    );

    return CheckResult(
        subscriptionStatus: SubscriptionStatus.named(
            resultMap?["subscriptionStatus"] as String),
        purchaseTimeMillis: resultMap?["purchaseTimeMillis"] as int?);
  }
}
