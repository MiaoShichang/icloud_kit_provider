import 'ikp_constants.dart';
import 'ikp_utils.dart';

class IkpRecord {
  final String recordType;
  final String recordName;
  final Map<String, dynamic> fields;

  IkpRecord({
    required this.recordType,
    required this.recordName,
    required this.fields,
  });

  factory IkpRecord.fromJson(Map<dynamic, dynamic> data) {
    return IkpRecord(
      recordType: IkpUtils.getStrValue(data[IkpConstants.recordType]),
      recordName: IkpUtils.getStrValue(data[IkpConstants.recordName]),
      fields: _parseRecordValue(data[IkpConstants.recordValue]),
    );
  }

  static Map<String, dynamic> _parseRecordValue(dynamic record) {
    if (record == null) return {};
    if (record is! Map) return {};
    return record.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  String toString() {
    return "IkpRecord{recordType: $recordType, recordName: $recordName, fields: $fields}";
  }
}
