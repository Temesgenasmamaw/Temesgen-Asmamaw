import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../config/env_config.dart';

@Singleton()
class HttpService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: EnvConfig.connectTimeout),
      receiveTimeout: const Duration(seconds: EnvConfig.receiveTimeout),
      sendTimeout: const Duration(seconds: EnvConfig.sendTimeout),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  HttpService() {
    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('[HTTP Request] ${options.method} -> ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[HTTP Response] ${response.statusCode} <- ${response.requestOptions.uri}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[HTTP Error] ${error.response?.statusCode ?? error.type}: ${error.message}',
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  // GET
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.get(
      url,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }

  // POST
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.post(
      url,
      data: data,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }

  // PUT
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.put(
      url,
      data: data,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }

  // DELETE
  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.delete(
      url,
      data: data,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }

  /// Inject an auth token for subsequent requests.
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove auth token (e.g. on logout).
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
