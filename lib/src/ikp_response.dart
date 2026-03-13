import 'ikp_utils.dart';

class IkpResponse<T> {
  final int code;
  final String msg;
  T? data;
  dynamic request;

  IkpResponse({this.code = -1, this.msg = "", this.data});

  factory IkpResponse.fromJson(Map<dynamic, dynamic> data) {
    var resp = IkpResponse<T>(
      code: IkpUtils.getIntValue(data["code"], defaultValue: -2),
      msg: IkpUtils.getStrValue(data["msg"]),
    );
    return resp;
  }

  bool isOK() => code == 0;

  @override
  String toString() {
    return "{code: $code, msg: $msg, data: $data, request: $request}";
  }
}
