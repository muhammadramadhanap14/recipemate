import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/constant_url.dart';
import '../utils/token_interceptor.dart';

class ApiRepository {
  late Dio _dio;
  late Dio _dioNews;

  ApiRepository() {
    BaseOptions options = BaseOptions(
      baseUrl: ConstantUrl.spoonacularUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(minutes: 4),
      receiveTimeout: const Duration(minutes: 4),
    );

    BaseOptions newsOptions = BaseOptions(
      baseUrl: ConstantUrl.foodNewsUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    );

    _dio = Dio(options);
    _dioNews = Dio(newsOptions);

    _dio.interceptors.add(TokenInterceptor());
    final logger = InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        debugPrint('Request to: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        debugPrint('Error: ${e.response?.statusCode} ${e.response?.data}');
        return handler.next(e);
      },
    );

    _dio.interceptors.add(logger);
    _dioNews.interceptors.add(logger);
  }
  Future<dynamic> postApiLogin(String email, String password) async {
    try {
      debugPrint('ApiRepository: POST ${ConstantUrl.authLogin}');
      final response = await _dio.post(
        ConstantUrl.authLogin,
        data: {"email": email, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      debugPrint("ApiRepository response login status: ${response.statusCode}");
      debugPrint("ApiRepository response login body: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint(
        "ApiRepository Dio error: ${e.response?.statusCode} ${e.response?.data}",
      );
      return e.response?.data;
    } catch (e) {
      debugPrint("ApiRepository error: $e");
      return null;
    }
  }

  Future<dynamic> postApiRegister(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      debugPrint('ApiRepository: POST ${ConstantUrl.authRegister}');
      final response = await _dio.post(
        ConstantUrl.authRegister,
        data: {"name": fullname, "email": email, "password": password},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      debugPrint(
        "ApiRepository response register status: ${response.statusCode}",
      );
      debugPrint("ApiRepository response register body: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint(
        "ApiRepository Dio error: ${e.response?.statusCode} ${e.response?.data}",
      );
      return e.response?.data;
    } catch (e) {
      debugPrint("ApiRepository error: $e");
      return null;
    }
  }

  Future<dynamic> getRecipesComplexSearch({
    required String query,
    int number = 150,
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
          "apiKey": ConstantUrl.spoonacularApiKey,
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

  Future<dynamic> getRandomRecipes({int number = 2}) async {
    try {
      final response = await _dio.get(
        "/recipes/random",
        queryParameters: {
          "number": number,
          "apiKey": ConstantUrl.spoonacularApiKey,
        },
      );

      log("response random: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<dynamic> getFoodNews({
    required String query,
    int number = 5,
    String sortBy = "relevancy",
  }) async {
    try {
      final response = await _dioNews.get(
        "everything",
        queryParameters: {
          "q": query,
          "pageSize": number,
          "apiKey": ConstantUrl.foodNewsApiKey,
          "language": "en",
          "sortBy": sortBy,
        },
      );

      log("response news: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio error news: ${e.response?.data}");
      return e.response?.data;
    } catch (e) {
      debugPrint("Error news: $e");
      return null;
    }
  }
}
