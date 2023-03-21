import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_checker/subscription_checker_method_channel.dart';

void main() {
  MethodChannelSubscriptionChecker platform = MethodChannelSubscriptionChecker();
  const MethodChannel channel = MethodChannel('subscription_checker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.checkSubscription(), '42');
  });
}
