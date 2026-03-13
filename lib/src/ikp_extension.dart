import 'ikp_utils.dart';

extension IkpResponseExtension on Map<dynamic, dynamic> {
  //
  int intValue(dynamic key, {int defaultValue = 0}) =>
      IkpUtils.getIntValue(this[key], defaultValue: defaultValue);

  String strValue(dynamic key, {String defaultValue = ""}) =>
      IkpUtils.getStrValue(this[key], defaultValue: defaultValue);

  double doubleValue(dynamic key, {double defaultValue = 0.0}) =>
      IkpUtils.getDoubleValue(this[key], defaultValue: defaultValue);

  Map<dynamic, dynamic>? mapValue(dynamic key) {
    if (containsKey(key)) {
      if (this[key] == null) return null;
      if (this[key] is Map) return this[key] as Map<dynamic, dynamic>;
    }
    return null;
  }

  List<dynamic>? listValue(dynamic key) {
    if (containsKey(key)) {
      if (this[key] == null) return null;
      if (this[key] is List) return this[key] as List<dynamic>;
    }
    return null;
  }

  //
  int get code => IkpUtils.getIntValue(this["code"], defaultValue: -2);

  String get msg =>
      IkpUtils.getStrValue(this["msg"], defaultValue: "do not find msg");

  dynamic get data => this["data"];

  //
}
