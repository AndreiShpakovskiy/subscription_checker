import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_checker/subscription_checker.dart';
import 'package:subscription_checker/subscription_checker_platform_interface.dart';
import 'package:subscription_checker/subscription_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSubscriptionCheckerPlatform
    with MockPlatformInterfaceMixin
    implements SubscriptionCheckerPlatform {

  @override
  Future<String?> checkSubscription() => Future.value('42');
}

void main() {
  final SubscriptionCheckerPlatform initialPlatform = SubscriptionCheckerPlatform.instance;

  test('$MethodChannelSubscriptionChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSubscriptionChecker>());
  });

  test('getPlatformVersion', () async {
    SubscriptionChecker subscriptionCheckerPlugin = SubscriptionChecker();
    MockSubscriptionCheckerPlatform fakePlatform = MockSubscriptionCheckerPlatform();
    SubscriptionCheckerPlatform.instance = fakePlatform;

    expect(await subscriptionCheckerPlugin.checkSubscription(), '42');
  });
}
