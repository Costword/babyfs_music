import 'global.dart';
import 'package:flutter/services.dart';

class Logger {
  factory Logger() => get();
  static Logger _instance;
  MethodChannel _logChannel = MethodChannel('LogMethodChannel');

  Logger._internal();

  static Logger get() {
    if (_instance == null) {
      _instance = Logger._internal();
    }
    return _instance;
  }

  void logE(String tag, Object object) {
    if(!mixDev) return;
    _logChannel.invokeMethod('logE', [
      {'tag': tag},
      {'error': object}
    ]);
  }

  void logI(String tag, Object object) {
    if(!mixDev) return;
    String line = "$object";
    _logChannel.invokeMethod('logI', [
      {'tag': tag},
      {'msg': line}
    ]);
  }
}
