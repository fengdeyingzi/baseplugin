import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'baseplugin_method_channel.dart';

abstract class BasepluginPlatform extends PlatformInterface {
  /// Constructs a BasepluginPlatform.
  BasepluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static BasepluginPlatform _instance = MethodChannelBaseplugin();

  /// The default instance of [BasepluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelBaseplugin].
  static BasepluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BasepluginPlatform] when
  /// they register themselves.
  static set instance(BasepluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
