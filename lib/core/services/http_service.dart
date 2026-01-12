import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef ErrorCallback = void Function(String message);

class HttpService {
  static final HttpService _instance = HttpService._internal();
  late Dio _dio;
  BuildContext? _context; // 添加 context 支持
  ErrorCallback? _errorCallback; // 错误回调

  factory HttpService() => _instance;

  HttpService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.3:8080/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 从本地存储获取 token 并添加到请求头
          String? token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 200) {
            // 在这里处理 JSON 解码
            if (response.data is String) {
              try {
                response.data = json.decode(response.data);
              } catch (e) {
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    type: DioExceptionType.badResponse,
                    error: 'JSON 解码失败',
                  ),
                );
              }
            }
            // 检查 API 返回的 code 是否为 "200"（字符串）
            if (response.data is Map) {
              var code = response.data['code'];
              if (code != '200' && code != 200) {
                // 同时检查字符串和数字形式
                String message = response.data['message'] ?? '请求失败';
                // 显示错误消息
                _showError(message);
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    type: DioExceptionType.badResponse,
                    error: message,
                    response: response,
                  ),
                );
              }
            }
            // print(response.data);
            // print('响应成功: ${response.requestOptions.uri}');
            return handler.next(response);
          } else {
            String message = '服务器返回错误: ${response.statusCode}';
            _showError(message);
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                type: DioExceptionType.badResponse,
                response: response,
                error: message,
              ),
            );
          }
        },
        onError: (DioException e, handler) {
          // 统一错误处理
          String message = _getErrorMessage(e);
          _showError(message);
          return handler.next(e);
        },
      ),
    );
  }

  // 设置上下文
  void setContext(BuildContext context) {
    _context = context;
  }

  // 设置错误回调
  void setErrorCallback(ErrorCallback callback) {
    _errorCallback = callback;
  }

  // 显示错误消息
  void _showError(String message) {
    if (_errorCallback != null) {
      _errorCallback!(message);
    } else if (_context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_context != null && _context!.mounted) {
          showDialog(
            context: _context!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('错误'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('确定'),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      // 如果没有设置 context 或回调，则打印到控制台
    }
  }

  // 获取错误消息
  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '网络连接超时，请检查网络后重试';
      case DioExceptionType.badResponse:
        if (e.response != null) {
          switch (e.response!.statusCode) {
            case 400:
              return '请求参数错误';
            case 401:
              return '未授权访问，请重新登录';
            case 403:
              return '禁止访问';
            case 404:
              return '请求的资源不存在';
            case 500:
              return '服务器内部错误';
            default:
              return '服务器错误 (${e.response!.statusCode}): ${e.response!.statusMessage}';
          }
        }
        return '服务器响应错误';
      case DioExceptionType.cancel:
        return '请求被取消';
      case DioExceptionType.connectionError:
        return '网络连接错误，请检查网络设置';
      case DioExceptionType.badCertificate:
        return '证书错误';
      case DioExceptionType.unknown:
        return '网络请求失败，请检查网络连接';
    }
  }

  // 获取 token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 保存 token
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // 清除 token
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // GET 请求
  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get(path, queryParameters: params);
  }

  // POST 请求
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT 请求
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE 请求
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
