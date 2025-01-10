import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'baseplugin_platform_interface.dart';

/// An implementation of [BasepluginPlatform] that uses method channels.
class MethodChannelBaseplugin extends BasepluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('baseplugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
