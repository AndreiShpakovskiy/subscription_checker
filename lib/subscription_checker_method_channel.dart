import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'subscription_checker_platform_interface.dart';

class MethodChannelSubscriptionChecker extends SubscriptionCheckerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('subscription_checker');

  @override
  Future<String?> checkSubscription({
    required List<String> subscriptionId,
  }) async {
    return methodChannel.invokeMethod<String>(
      'checkSubscription',
      {"subscriptionId": subscriptionId},
    );
  }
}
