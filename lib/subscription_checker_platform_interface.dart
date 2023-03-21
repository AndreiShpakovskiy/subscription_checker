import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'subscription_checker_method_channel.dart';

abstract class SubscriptionCheckerPlatform extends PlatformInterface {
  SubscriptionCheckerPlatform() : super(token: _token);

  static final Object _token = Object();
  static SubscriptionCheckerPlatform _instance =
      MethodChannelSubscriptionChecker();

  static SubscriptionCheckerPlatform get instance => _instance;

  static set instance(SubscriptionCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> checkSubscription() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
