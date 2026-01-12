import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  late final Dio _dio;
  BuildContext? _context;

  factory HttpService() => _instance;

  HttpService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.3:8080',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType, // ⭐ 核心
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 确保所有请求都是 JSON
          options.contentType = Headers.jsonContentType;
          options.headers['Accept'] = 'application/json';

          // 如果以后用 token
          // options.headers['Authorization'] = 'Bearer $token';

          debugPrint('➡️ ${options.method} ${options.uri}');
          debugPrint('➡️ Body: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;

          // 统一业务错误处理（适配 Spring Boot 返回结构）
          if (data is Map<String, dynamic>) {
            final code = data['code'];

            if (code != null && code != 200) {
              final message = data['message'] ?? '请求失败';
              _showErrorDialog(message);

              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  type: DioExceptionType.badResponse,
                  response: response,
                  error: message,
                ),
              );
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final message = _getErrorMessage(e);
          _showErrorDialog(message);
          return handler.next(e);
        },
      ),
    );
  }

  /// 设置页面上下文（用于弹窗）
  void setContext(BuildContext context) {
    _context = context;
  }

  /* ===================== 请求方法 ===================== */

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) {
    return _dio.get<T>(path, queryParameters: params);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(
      path,
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return _dio.put<T>(
      path,
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<Response<T>> delete<T>(String path, {dynamic data}) {
    return _dio.delete<T>(
      path,
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  /* ===================== 错误处理 ===================== */

  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.sendTimeout:
        return '请求发送超时';
      case DioExceptionType.receiveTimeout:
        return '响应超时';
      case DioExceptionType.badResponse:
        return e.response?.data?['message'] ?? e.error?.toString() ?? '服务器错误';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '网络连接失败';
      case DioExceptionType.badCertificate:
        return '证书错误';
      case DioExceptionType.unknown:
        return e.message ?? '未知错误';
    }
  }

  void _showErrorDialog(String message) {
    if (_context == null) {
      debugPrint('HTTP Error: $message');
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_context != null && _context!.mounted) {
        showDialog(
          context: _context!,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('错误'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(_context!).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    });
  }
}
