import 'package:flutter_test/flutter_test.dart';
import 'package:baseplugin/baseplugin.dart';
import 'package:baseplugin/baseplugin_platform_interface.dart';
import 'package:baseplugin/baseplugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBasepluginPlatform
    with MockPlatformInterfaceMixin
    implements BasepluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BasepluginPlatform initialPlatform = BasepluginPlatform.instance;

  test('$MethodChannelBaseplugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBaseplugin>());
  });

  test('getPlatformVersion', () async {
    Baseplugin basepluginPlugin = Baseplugin();
    MockBasepluginPlatform fakePlatform = MockBasepluginPlatform();
    BasepluginPlatform.instance = fakePlatform;

    expect(await basepluginPlugin.getPlatformVersion(), '42');
  });
}
