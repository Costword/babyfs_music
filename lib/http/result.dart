class Result<T> {
  int code;
  String msg;
  T data;
  bool notFound;
  bool success;

  Result({this.code, this.msg, this.data, this.notFound, this.success});

  Result.fromJson(Map<String, dynamic> json, ParseJson<T> parseFunc, ParseJsonArray<T> parseArrayFunc) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      var jsonData = json['data'];
      if (jsonData is Map<String, dynamic> && parseFunc != null) {
        data = parseFunc(jsonData);
      } else if (jsonData is List && parseArrayFunc != null) {
        data = parseArrayFunc(jsonData);
      } else {
        data = jsonData;
      }
    } else {
      data = null;
    }
    notFound = json['notFound'];
    success = json['success'];
    msg = json['msg'];
  }
}

typedef D ParseJson<D>(Map<String, dynamic> json);
typedef D ParseJsonArray<D>(List json);
