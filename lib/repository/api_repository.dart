import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/constant_url.dart';

class ApiRepository {
  late Dio _dio;

  ApiRepository() {
    BaseOptions options = BaseOptions(
        baseUrl: ConstantUrl.spoonacularUrl,
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
        "${ConstantUrl.recipemateUrl}/auth/login",
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

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<dynamic> postApiRegister(
    String fullname,
    String email,
    String password,
    ) async {
    try {
      final response = await _dio.post(
        "${ConstantUrl.recipemateUrl}/auth/register",
        data: {
          "name": fullname,
          "email": email,
          "password": password,
        },
      );

      debugPrint("response register: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<dynamic> getRecipesComplexSearch({
    required String query,
    int number = 20,
  }) async {
    try {
      final response = await _dio.get(
        "/recipes/complexSearch",
        queryParameters: {
          "query": query,
          "number": number,
          "apiKey": ConstantUrl.spoonacularApiKey,
        },
      );

      log("response search: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<dynamic> getRecipeAutocomplete({
    required String query,
    int number = 5,
  }) async {
    try {
      final response = await _dio.get(
        "/recipes/autocomplete",
        queryParameters: {
          "query": query,
          "number": number,
          "apiKey": ConstantUrl.spoonacularApiKey2,
        },
      );

      log("response autocomplete: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<dynamic> getRecipeInformation(int recipeId) async {
    try {
      final response = await _dio.get(
        "/recipes/$recipeId/information",
        queryParameters: {
          "includeNutrition": true,
          "apiKey": ConstantUrl.spoonacularApiKey,
        },
      );

      log("response detail: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }
}