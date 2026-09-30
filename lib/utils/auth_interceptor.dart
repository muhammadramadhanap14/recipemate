import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/data_session_util.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';

class AuthInterceptor extends Interceptor {
  bool _isLoggingOut = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      debugPrint("AuthInterceptor onRequest error: $e");
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;
      final retried = options.extra['retried'] == true;

      if (!retried) {
        options.extra['retried'] = true;
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final newToken = await user.getIdToken(true);
            if (newToken != null && newToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $newToken';
              final dio = Dio();
              final response = await dio.fetch(options);
              return handler.resolve(response);
            }
          }
        } catch (e) {
          debugPrint("AuthInterceptor token refresh failed: $e");
          if (e is FirebaseAuthException &&
              ['user-token-expired', 'user-disabled', 'user-not-found', 'invalid-user-token'].contains(e.code)) {
            await _forceLogout();
          }
        }
      } else {
        await _forceLogout();
      }
    } else if (_isNetworkError(err)) {
      return handler.next(err);
    }

    return handler.next(err);
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.error is SocketException;
  }

  Future<void> _forceLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context) : null;

    try {
      final authService = Get.isRegistered<FirebaseAuthService>()
          ? Get.find<FirebaseAuthService>()
          : FirebaseAuthService();
      await authService.signOut();
      await DataSessionUtil().clearSession();

      if (l10n != null) {
        AppSnackbar.show(title: l10n.stError, message: l10n.stSessionExpiredMessage);
      }
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint("Force logout error: $e");
    } finally {
      _isLoggingOut = false;
    }
  }
}
