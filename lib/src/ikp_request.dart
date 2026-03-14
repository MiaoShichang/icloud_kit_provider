import '../icloud_kit_provider.dart';
import 'ikp_account_status.dart';
import 'ikp_constants.dart';
import 'ikp_handler.dart';
import 'ikp_utils.dart';

class IkpRequest implements IcloudKitProvider {
  late IkpHandler handler;

  IkpRequest({
    required String containerId,
    IkpDatabaseScope scope = IkpDatabaseScope.private,
  }) {
    handler = IkpHandler(containerId: containerId, scope: scope);
  }

  @override
  Future<IkpResponse> getAccountStatus() async {
    var result = await handler.call(method: IkpConstants.getAccountStatus);
    try {
      IkpResponse<IkpAccountStatus> response = IkpResponse.fromJson(result);
      int status = result.intValue(IkpConstants.data, defaultValue: 100);
      response.data = IkpAccountStatus.from(status);
      return response;
    } catch (e) {
      return IkpResponse(code: -300, msg: "$e");
    }
  }

  @override
  Future<IkpResponse<IkpRecord>> saveRecord({
    required String recordType,
    required Map<String, dynamic> fields,
    String? recordName,
  }) async {
    if (!IkpUtils.validateKey(recordType)) {
      return IkpResponse(
        code: -400,
        msg: "recordType[\"$recordType\"] is invalid",
      );
    }
    if (fields.keys.isEmpty) {
      return IkpResponse(code: -401, msg: "fields is empty");
    }

    List<String> errKeys = [];
    List<String> errValues = [];
    fields.forEach((key, value) {
      if (!IkpUtils.validateKey(key)) {
        errKeys.add(key);
      }
      if (value is num || value is String || value is bool) {
      } else {
        errValues.add("\"$key\": $value");
      }
    });

    String msg = "";
    if (errKeys.isNotEmpty) {
      msg += "fieldName [\"${errKeys.join("\", \"")}\"] is invalid;";
    }
    if (errValues.isNotEmpty) {
      msg += "fieldValue [${errValues.join(", ")}] is invalid;";
    }
    if (msg.isNotEmpty) {
      return IkpResponse(code: -402, msg: msg);
    }

    var result = await handler.call(
      method: IkpConstants.saveRecord,
      params: {
        IkpConstants.recordType: recordType,
        IkpConstants.recordName: recordName,
        IkpConstants.recordValue: fields,
      },
    );
    try {
      IkpResponse<IkpRecord> response = IkpResponse.fromJson(result);
      if (result.data != null && result.data is Map) {
        response.data = IkpRecord.fromJson(result.data);
      }
      return response;
    } catch (e) {
      return IkpResponse(code: -300, msg: "$e");
    }
  }

  @override
  Future<IkpResponse<IkpRecord>> getRecord({required String recordName}) async {
    var result = await handler.call(
      method: IkpConstants.getRecord,
      params: {IkpConstants.recordName: recordName},
    );
    try {
      IkpResponse<IkpRecord> response = IkpResponse.fromJson(result);
      if (result.data != null && result.data is Map) {
        response.data = IkpRecord.fromJson(result.data);
      }
      return response;
    } catch (e) {
      return IkpResponse(code: -300, msg: "$e");
    }
  }

  @override
  Future<IkpResponse<IkpListRecord>> getRecords({
    required String recordType,
    String cursor = "",
    int limit = 20,
    List<String>? fields,
  }) async {
    if (limit > 100) limit = 100;
    if (limit <= 0) limit = 20;

    var result = await handler.call(
      method: IkpConstants.getRecords,
      params: {
        IkpConstants.recordType: recordType,
        IkpConstants.limit: limit,
        IkpConstants.cursor: cursor,
        IkpConstants.fields: fields,
      },
    );

    try {
      IkpResponse<IkpListRecord> response = IkpResponse.fromJson(result);
      if (result.data != null && result.data is Map) {
        response.data = IkpListRecord.fromJson(result.data);
      }
      return response;
    } catch (e) {
      return IkpResponse(code: -300, msg: "$e");
    }
  }

  @override
  Future<IkpResponse<List<IkpRecord>>> getAll({
    required String recordType,
    List<String>? fields,
  }) async {
    List<IkpRecord> datalist = [];
    var limit = 100;
    var rlr = await getRecords(
      recordType: recordType,
      limit: limit,
      fields: fields,
    );
    IkpResponse<List<IkpRecord>> response = IkpResponse(
      code: rlr.code,
      msg: rlr.msg,
    );
    if (!response.isOK()) return response;
    if (rlr.data == null) return response;

    if (rlr.data!.list.isNotEmpty) {
      datalist.addAll(rlr.data!.list);
    }

    var cursor = rlr.data?.cursor ?? "";
    while (cursor.isNotEmpty) {
      var result = await getRecords(
        recordType: recordType,
        limit: limit,
        cursor: cursor,
        fields: fields,
      );
      if (result.isOK() &&
          result.data != null &&
          result.data!.list.isNotEmpty) {
        datalist.addAll(result.data!.list);
      }
      cursor = result.data?.cursor ?? "";
    }
    response.data = datalist;
    return response;
  }

  @override
  Future<IkpResponse<String>> deleteRecord({required String recordName}) async {
    var result = await handler.call(
      method: IkpConstants.deleteRecord,
      params: {IkpConstants.recordName: recordName},
    );
    var response = IkpResponse<String>.fromJson(result);
    if (result.data != null && result.data is String) {
      response.data = result.data;
    }
    return response;
  }

  @override
  Future<IkpResponse<int>> clearRecord({required String recordType}) async {
    int all = 0;
    while (true) {
      var result = await getRecords(
        recordType: recordType,
        limit: 50,
        fields: [],
      );
      if (result.data == null) break;
      if (result.data!.list.isEmpty) break;
      for (var item in result.data!.list) {
        var r = await deleteRecord(recordName: item.recordName);
        if (r.isOK()) all++;
      }
    }
    IkpResponse<int> response = IkpResponse(code: 0, msg: "success");
    response.data = all;
    return response;
  }

  @override
  Future<IkpResponse<IkpListRecord>> findRecords({
    required String recordType,
    List<IkpFilter>? filters,
    List<IkpSort>? sortFields,
    List<String>? fields,
    String? cursor,
    int limit = 20,
  }) async {
    Map<String, dynamic> params = {IkpConstants.recordType: recordType};
    if (fields != null) {
      params[IkpConstants.fields] = fields;
    }
    if (cursor != null && cursor.isNotEmpty) {
      params[IkpConstants.cursor] = cursor;
    }
    if (limit > 100) limit = 100;
    if (limit <= 0) limit = 20;
    params[IkpConstants.limit] = limit;

    if (filters != null) {
      List<Map<String, dynamic>> filterList = [];
      for (var filter in filters) {
        if (filter.isValid()) {
          filterList.add(filter.toJson());
        }
      }
      if (filterList.isNotEmpty) {
        params[IkpConstants.filters] = filterList;
      }
    }

    if (sortFields != null) {
      List<Map<String, dynamic>> sortList = [];
      for (var sort in sortFields) {
        if (sort.isValid()) {
          sortList.add(sort.toJson());
        }
      }
      if (sortList.isNotEmpty) {
        params[IkpConstants.sortFields] = sortList;
      }
    }

    var result = await handler.call(
      method: IkpConstants.findRecords,
      params: params,
    );

    try {
      IkpResponse<IkpListRecord> response = IkpResponse.fromJson(result);
      if (result.data != null && result.data is Map) {
        response.data = IkpListRecord.fromJson(result.data);
      }
      return response;
    } catch (e) {
      return IkpResponse(code: -300, msg: "$e");
    }
  }
}
