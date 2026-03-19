import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'icloud_kit_provider_platform_interface.dart';

/// An implementation of [IcloudKitProviderPlatform] that uses method channels.
class MethodChannelIcloudKitProvider extends IcloudKitProviderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('icloud_kit_provider');

  /// 实现自定义接口
  @override
  Future<Map<dynamic, dynamic>> call(Map<dynamic, dynamic> data) async {
    try {
      Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'handler',
        data,
      );
      return result;
    } catch (e) {
      return {"code": -101, "msg": "$e"};
    }
  }
}
