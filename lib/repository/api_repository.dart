import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/constant_url.dart';

class ApiRepository {
  late Dio _dio;

  ApiRepository() {
    BaseOptions options = BaseOptions(
        // baseUrl: ConstantUrl.recipemateUrl, // nanti ini di un comment
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
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        "http://localhost:3000/login", // 🔥 endpoint kamu
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      debugPrint("response login: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Login gagal");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio error: ${e.response?.data}");
        return e.response?.data;
      } else {
        debugPrint("Error: $e");
        return null;
      }
    }
  }

  Future<dynamic> postApiRegister(
    String fullname,
    String email,
    String password,
    ) async {
    try {
      final response = await _dio.post(
        "http://localhost:3000/register",
        data: {
          "name": fullname,
          "email": email,
          "password": password,
        },
      );

      debugPrint("response register: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Register gagal");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio error: ${e.response?.data}");
        return e.response?.data;
      } else {
        debugPrint("Error: $e");
        return null;
      }
    }
  }
}