import '../icloud_kit_provider_platform_interface.dart';
import 'ikp_constants.dart';
import 'ikp_database_scope.dart';
import 'ikp_utils.dart';

class IkpHandler {
  String containerId = "";
  IkpDatabaseScope scope;

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
    return await IcloudKitProviderPlatform.instance.call(data);
  }
}
