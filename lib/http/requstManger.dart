import 'dart:io';
import 'package:flutter/services.dart';

import 'global.dart' as global;
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'api.dart';
import 'logerInterceptor.dart';
import 'result.dart';

class DioClient {
  factory DioClient() => _getInstance();
  static DioClient _instance;
  static DioClient get instance => _getInstance();
  Dio _dio;
  MethodChannel _methodChannel = MethodChannel("UserMethodChannel");

  /// 获取单例内部方法
  static DioClient _getInstance() {
    if (_instance == null) {
      _instance = DioClient._myinternal();
    }
    return _instance;
  }

  DioClient._myinternal() {
    if (_dio == null) {
      // 配置dio
      BaseOptions options = BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000,
      );
      print("配置DioClient的baseurl是: ${Api.baseUrl}");
      _dio = Dio(options);
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                host.startsWith('a.api.babyfs.cn');
        return client;
      };
      // iOS下有问题，暂时只在 Android 启用
      if (Platform.isAndroid) {
        // setProxy();
        print("Android情况下配置");
      }
      _dio.interceptors.add(QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (global.mixDev) {
            var headers = await _methodChannel.invokeMethod('getHeader');
            Map<String, dynamic>.from(headers)
                .keys
                .forEach((key) => options.headers[key] = headers[key]);
            options.headers['Content-Type'] = 'application/json; charset=utf-8';
            handler.next(options);
          } else {
            if (global.shouldMockHeader) {
              Map<String, dynamic>.from(global.mockHeader).keys.forEach(
                  (key) => options.headers[key] = global.mockHeader[key]);
              handler.next(options);
            }
          }
        },
      ));
      // 由于拦截器队列的执行顺序是FIFO，如果把log拦截器添加到了最前面，则后面拦截器对options的更改就不会被打印（但依然会生效）
      // 所以建议把log拦截添加到队尾。
      _dio.interceptors.add(MLogerInterceptor());
    }
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
    ParseJson parseFunc,
    ParseJsonArray parseArrayFunc,
    Function onComplete,
    Function(DioError error) onError,
  }) async {
    Response response;
    try {
      response = await _dio.get(url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      if (response.statusCode == 200) {
        var result =
            Result<T>.fromJson(response.data, parseFunc, parseArrayFunc);
        if (onComplete != null) {
          onComplete(result.code, result.msg);
        }
        if (result.code == 0) {
          return result.data;
        }
      } else if (response.statusCode == 401) {
        //去登陆
        print("需要登陆");
      } else {
        // return response.statusCode;
        print("接口报错${response.statusCode}");
      }
    } on DioError catch (e) {
      print(e.toString());
      if (onError != null) {
        onError(e);
      }
    }
  }

  Future<T> post<T>(String url,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      ParseJson parseFunc,
      ParseJsonArray parseArrayFunc,
      Function onComplete}) async {
    Response response;
    try {
      response = await _dio.post(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      if (response.statusCode == 200) {
        var result =
            Result<T>.fromJson(response.data, parseFunc, parseArrayFunc);
        if (onComplete != null) {
          onComplete(result.code, result.msg);
        }
        if (result.code == 0) {
          return result.data;
        }
      } else if (response.statusCode == 401) {
        //去登陆

      } else {
        // return response.statusCode;
      }
    } on DioError catch (e) {
      print(e.toString());
    }
  }

  Future<T> fetchRemote<T>(
      {String url, ParseJson parseFunc, ParseJsonArray parseArrayFunc}) {
    try {
      return get(url, parseFunc: parseFunc, parseArrayFunc: parseArrayFunc);
    } catch (e) {
      return null;
    }
  }

  Future<Response> downloadFile(String resUrl, String savePath) async {
    return await _dio.download(resUrl, savePath);
  }
}
