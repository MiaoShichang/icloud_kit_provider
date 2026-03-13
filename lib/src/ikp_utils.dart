import 'dart:developer';

class IkpUtils {
  static final _ikpKeyRegexp = RegExp(r'^[a-zA-Z]\w+$');
  static final _ikpLetterRegexp = RegExp(r'^[a-zA-Z]$');

  // key 必须是以字母开头，后面可以跟字母、数字或下划线
  static bool validateKey(String key) {
    bool isOK = _ikpLetterRegexp.hasMatch(key) || _ikpKeyRegexp.hasMatch(key);
    return isOK;
  }

  static String validateKeyInfo(String key) {
    bool isOK = _ikpLetterRegexp.hasMatch(key) || _ikpKeyRegexp.hasMatch(key);
    if (isOK) {
      return "key[$key] is OK";
    } else {
      return "key[$key] is not valid";
    }
  }

  static int getIntValue(dynamic obj, {int defaultValue = 0}) {
    if (obj == null) return defaultValue;
    if (obj is int) return obj;
    if (obj is num) return obj.toInt();
    if (obj is String) return int.tryParse(obj) ?? defaultValue;
    return defaultValue;
  }

  static String getStrValue(dynamic obj, {String defaultValue = ""}) {
    if (obj == null) return defaultValue;
    if (obj is String) return obj;
    return obj.toString();
  }

  static double getDoubleValue(dynamic obj, {double defaultValue = 0.0}) {
    if (obj == null) return defaultValue;
    if (obj is double) return obj;
    if (obj is num) return obj.toDouble();
    if (obj is String) return double.tryParse(obj) ?? defaultValue;
    return defaultValue;
  }

  static bool getBoolValue(dynamic obj, {bool defaultValue = false}) {
    if (obj == null) return defaultValue;
    if (obj is bool) return obj;
    if (obj is num) return obj.toInt() != 0;
    if (obj is String) return bool.tryParse(obj) ?? defaultValue;
    return defaultValue;
  }

  static Map<dynamic, dynamic>? removeNull(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    if (map.isEmpty) return map;
    try {
      map.removeWhere((key, value) => value == null);
    } catch (e) {
      log("remove null error: $e");
    }
    return map;
  }
}
