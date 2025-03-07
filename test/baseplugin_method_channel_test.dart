import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:baseplugin/baseplugin_method_channel.dart';

void main() {
  MethodChannelBaseplugin platform = MethodChannelBaseplugin();
  const MethodChannel channel = MethodChannel('baseplugin');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
