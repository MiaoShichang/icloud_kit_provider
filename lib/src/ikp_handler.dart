import 'dart:developer';

import '../icloud_kit_provider_platform_interface.dart';
import 'ikp_constants.dart';
import 'ikp_database_scope.dart';
import 'ikp_utils.dart';

class IkpHandler {
  String containerId = "";
  IkpDatabaseScope scope;

  static bool showLog = false;

  IkpHandler({this.containerId = "", this.scope = IkpDatabaseScope.private});

  Future<Map<dynamic, dynamic>> call({
    required String method,
    Map<dynamic, dynamic> params = const {},
  }) async {
    Map<dynamic, dynamic> data = {
      IkpConstants.containerId: containerId,
      IkpConstants.scope: scope.value,
      IkpConstants.method: method,
      IkpConstants.params: IkpUtils.removeNull(params),
    };
    var result = await IcloudKitProviderPlatform.instance.call(data);
    if (showLog) _showLog(data, result);
    return result;
  }

  void _showLog(Map<dynamic, dynamic> request, Map<dynamic, dynamic> response) {
    log("""******IcloudKitProvider******
request:
$request
response:
$response
*****************************""");
  }
}
