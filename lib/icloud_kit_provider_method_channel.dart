import 'dart:developer';

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
  Future<Map<dynamic, dynamic>> call(Map<dynamic, dynamic> handler) async {
    var flag = DateTime.now().millisecondsSinceEpoch;
    log("""request params from flutter : $flag
*******************************
$handler
*******************************""");
    try {
      Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'handler',
        handler,
      );

      log("""response result from ios : $flag
-------------------------------
$result
-------------------------------""");
      return result;
    } catch (e) {
      log("response result from ios error: $e");
      return {"code": -101, "msg": "$e"};
    }
  }

  //
  // @override
  // Future<IkpAccountStatus> getAccountStatus({String? containerId}) async {
  //   final args = containerId == null ? {} : {'containerId': containerId};
  //   int rawStatus = await methodChannel.invokeMethod('getAccountStatus', args);
  //   try {
  //     return IkpAccountStatus.values[rawStatus];
  //   } catch (_) {
  //     return IkpAccountStatus.unknown;
  //   }
  // }
  //
  // @override
  // Future<void> saveRecord({
  //   String? containerId,
  //   required IkpDatabaseScope scope,
  //   required String recordType,
  //   required Map<String, String> record,
  //   String? recordName,
  // }) async {
  //   var args = {
  //     'databaseScope': scope.name,
  //     'recordType': recordType,
  //     'record': record,
  //   };
  //   if (containerId != null) {
  //     args['containerId'] = containerId;
  //   }
  //   if (recordName != null) {
  //     args['recordName'] = recordName;
  //   }
  //   await methodChannel.invokeMethod('saveRecord', args);
  // }
  //
  // @override
  // Future<IkpRecord> getRecord({
  //   String? containerId,
  //   required IkpDatabaseScope scope,
  //   required String recordName,
  // }) async {
  //   var args = {'databaseScope': scope.name, 'recordName': recordName};
  //   if (containerId != null) {
  //     args['containerId'] = containerId;
  //   }
  //   Map<Object?, Object?> result = await methodChannel.invokeMethod(
  //     'getRecord',
  //     args,
  //   );
  //
  //   return IkpRecord.fromMap(result);
  // }
  //
  // @override
  // Future<List<IkpRecord>> getRecordsByType({
  //   String? containerId,
  //   required IkpDatabaseScope scope,
  //   required String recordType,
  // }) async {
  //   var args = {'databaseScope': scope.name, 'recordType': recordType};
  //   if (containerId != null) {
  //     args['containerId'] = containerId;
  //   }
  //
  //   List<Object?> result = await methodChannel.invokeMethod(
  //     'getRecordsByType',
  //     args,
  //   );
  //
  //   try {
  //     return result
  //         .map((e) => e as Map<Object?, Object?>)
  //         .map(IkpRecord.fromMap)
  //         .toList();
  //   } catch (e) {
  //     throw Exception('Cannot parse cloud kit response: $e');
  //   }
  // }
  //
  // @override
  // Future<void> deleteRecord({
  //   String? containerId,
  //   required IkpDatabaseScope scope,
  //   required String recordName,
  // }) async {
  //   var args = {'databaseScope': scope.name, 'recordName': recordName};
  //   if (containerId != null) {
  //     args['containerId'] = containerId;
  //   }
  //   await methodChannel.invokeMethod('deleteRecord', args);
  // }
}
