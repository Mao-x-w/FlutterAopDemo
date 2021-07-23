import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifecycle_detect/lifecycle_detect.dart';

void main() {
  const MethodChannel channel = MethodChannel('lifecycle_detect');

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
    expect(await LifecycleDetect.platformVersion, '42');
  });
}
