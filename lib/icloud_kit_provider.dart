library;

import 'src/ikp_database_scope.dart';
import 'src/ikp_filter.dart';
import 'src/ikp_list_record.dart';
import 'src/ikp_record.dart';
import 'src/ikp_request.dart';
import 'src/ikp_response.dart';
import 'src/ikp_sort.dart';

export 'src/ikp_database_scope.dart';
export 'src/ikp_extension.dart';
export 'src/ikp_filter.dart';
export 'src/ikp_list_record.dart';
export 'src/ikp_record.dart';
export 'src/ikp_response.dart';
export 'src/ikp_sort.dart';

/// iCloud Kit Provider.
abstract class IcloudKitProvider {
  /// Creates a new instance of [IcloudKitProvider].
  factory IcloudKitProvider({
    String? containerId,
    IkpDatabaseScope scope = IkpDatabaseScope.private,
  }) {
    return IkpRequest(containerId: containerId!, scope: scope);
  }

  /// Gets the user's account status.
  Future<IkpResponse> getAccountStatus() async {
    throw UnimplementedError('getAccountStatus() has not been implemented.');
  }

  /// Add or update a record.
  Future<IkpResponse<IkpRecord>> saveRecord({
    required String recordType,
    required Map<String, dynamic> fields,
    String? recordName,
  }) async {
    throw UnimplementedError('saveRecord() has not been implemented.');
  }

  /// Get a record by name.
  Future<IkpResponse<IkpRecord>> getRecord({required String recordName}) async {
    throw UnimplementedError('getRecord() has not been implemented.');
  }

  /// Get a list of records
  Future<IkpResponse<IkpListRecord>> getRecords({
    required String recordType,
    String cursor = "",
    int limit = 20,
    List<String>? fields,
    List<IkpSort>? sortFields,
  }) async {
    throw UnimplementedError('getRecords() has not been implemented.');
  }

  /// Get all records
  Future<IkpResponse<List<IkpRecord>>> getAll({
    required String recordType,
    List<String>? fields,
    List<IkpSort>? sortFields,
  }) async {
    throw UnimplementedError('getAll() has not been implemented.');
  }

  /// Delete a record
  Future<IkpResponse<String>> deleteRecord({required String recordName}) async {
    throw UnimplementedError('deleteRecord() has not been implemented.');
  }

  /// Clear all records
  Future<IkpResponse<int>> clearRecord({required String recordType}) async {
    throw UnimplementedError('clearRecord() has not been implemented.');
  }

  /// Find records
  Future<IkpResponse<IkpListRecord>> findRecords({
    required String recordType,
    List<IkpFilter>? filters,
    List<IkpSort>? sortFields,
    List<String>? fields,
    String? cursor,
    int limit = 20,
  }) async {
    throw UnimplementedError('findRecords() has not been implemented.');
  }
}
