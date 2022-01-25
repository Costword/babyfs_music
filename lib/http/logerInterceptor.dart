//网络请求拦截器
import 'dart:io';
import 'package:dio/dio.dart';
import 'logger.dart';
import 'global.dart';
import 'global.dart' as global;

 class MLogerInterceptor extends LogInterceptor {

   MLogerInterceptor()
      : super(
          requestBody: global.debug,
          responseBody: global.debug,
        );
        static const String TAG = "httplog";
  Logger _logger = Logger.get();


@override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      var uri = options?.uri;
      var msg = "Request ${options.method} ${uri.toString()}";
      var params = "\nparams=${options?.queryParameters?.toString() ?? ""}";
      _logger.logI(TAG, msg + params);
    } catch (e) {}
    super.onRequest(options, handler);
  }

@override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
      try {
      var uri = response.realUri;
      var content = response.toString();
      var msg = "Response ${uri.toString()} \n $content";
      _logger.logI(TAG, msg);
    } catch (e) {}
    super.onResponse(response, handler);
  }

@override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    
    _logger.logE(TAG, 'HTTP FAILED ${err.response.realUri} \n ${err.toString()}');
    super.onError(err, handler);
  }
 }