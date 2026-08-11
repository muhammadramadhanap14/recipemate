import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:recipemate/utils/view_utils/view_dialog_util.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final currentRoute = Get.currentRoute;
      if (currentRoute != '/' && currentRoute != '/login' && currentRoute != '/register') {
        final context = Get.context;
        if (context != null) {
          ViewDialogUtil.showReloginDialog(context);
        }
      }
    }
    super.onError(err, handler);
  }
}