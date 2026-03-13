import 'ikp_constants.dart';
import 'ikp_record.dart';
import 'ikp_utils.dart';

class IkpListRecord {
  final List<IkpRecord> list;
  final String cursor;
  final int limit;

  IkpListRecord({required this.list, this.limit = 20, this.cursor = ""});

  factory IkpListRecord.fromJson(Map<dynamic, dynamic> data) {
    List<IkpRecord> list = [];
    var l = data["list"];
    if (l != null && l is List) {
      list = l.map((e) => IkpRecord.fromJson(e)).toList();
    }
    var limit = IkpUtils.getIntValue(
      data[IkpConstants.limit],
      defaultValue: 20,
    );

    var cursor = IkpUtils.getStrValue(data[IkpConstants.cursor]);

    return IkpListRecord(list: list, limit: limit, cursor: cursor);
  }

  @override
  String toString() {
    String content = "IkpListRecord[";
    for (var one in list) {
      content = "$content$one，";
    }
    content = "$content]";
    return content;
  }
}
