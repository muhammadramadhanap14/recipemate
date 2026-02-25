import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/constant_url.dart';
import '../utils/constant_var.dart';

class ApiRepository {
  late Dio _dio;

  ApiRepository() {
    BaseOptions options = BaseOptions(
        // baseUrl: ConstantUrl.recipemateUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 4),
        receiveTimeout: const Duration(minutes: 4));

    _dio = Dio(options);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Print request data
        debugPrint('Request to: ${options.uri}');
        debugPrint('Request data: ${options.data}');
        return handler.next(options); // Continue with the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Print response data
        // debugPrint('Response data: ${response.data}');
        return handler.next(response); // Continue with the response
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        // Print error
        debugPrint('Error: ${e.response?.statusCode} ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<dynamic> postApiLogin(
    String username,
    String password,
    String terminal,
    ) async {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    _dio.options.headers["content-Type"] = 'application/json';

    try {
      var response = await _dio.post('PP0001',
          options:
          Options(headers: <String, String>{'authorization': basicAuth}),
          data: {
            "useid" : username,
            "zpass" : password,
            "terminal" : terminal
      });

      // debugPrint("response login  ${jsonEncode(response.data)}");
      debugPrint("response login  ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      if (e is DioException) {
        if(e.type == DioExceptionType.connectionTimeout) {
          log("Connection Timeout Exception: ${e.message}");
          return ConstantVar.stTimeOutConnection;
        } else {
          log("DioException: ${e.message}");
          log("Request options: ${e.requestOptions}");
          debugPrint(e.toString());
          return null;
        }
      } else {
        log("Exception: $e");
        debugPrint(e.toString());
        return null;
      }
    }
  }

}