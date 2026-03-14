import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'icloud_kit_provider_method_channel.dart';

abstract class IcloudKitProviderPlatform extends PlatformInterface {
  /// Constructs a IcloudKitProviderPlatform.
  IcloudKitProviderPlatform() : super(token: _token);

  static final Object _token = Object();

  static IcloudKitProviderPlatform _instance = MethodChannelIcloudKitProvider();

  /// The default instance of [IcloudKitProviderPlatform] to use.
  ///
  /// Defaults to [MethodChannelIcloudKitProvider].
  static IcloudKitProviderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IcloudKitProviderPlatform] when
  /// they register themselves.
  static set instance(IcloudKitProviderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<dynamic, dynamic>> call(Map<dynamic, dynamic> data) async {
    throw UnimplementedError('call() has not been implemented.');
  }
}
