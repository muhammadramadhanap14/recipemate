import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/data_session_util.dart';
import '../../../models/model/chat_session.dart';
import '../../../repository/chat_api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class SplashViewModel extends GetxController {
  final BuildContext context;
  final startIconAnimation = false.obs;
  final startTextAnimation = false.obs;
  final isLoading = false.obs;
  final splashDuration = const Duration(milliseconds: 3500);
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  SplashViewModel({
    required this.context,
  });

  @override
  void onInit() {
    super.onInit();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    Future.delayed(const Duration(milliseconds: 400), () {
      startIconAnimation.value = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      startTextAnimation.value = true;
    });
    await initCheckConnection();
  }

  Future<void> initCheckConnection() async {
    final valConnection = await RecipeMateAppUtil.checkConnection();
    if (valConnection) {
      isLoading.value = true;
      await Future.delayed(splashDuration);
      final sessionUtil = Get.find<DataSessionUtil>();
      final token = await sessionUtil.getToken();
      if (token == null || token.isEmpty) {
        Get.offAllNamed('/login');
        return;
      }
      await _handleLaunchFromNotification(
        token,
        sessionUtil,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ViewDialogUtil().showOneButtonActionDialog(
          AppLocalizations.of(context)!.stNoConnectionMessage,
          AppLocalizations.of(context)!.backBtnTitle,
          ConstantVar.noConnectionGif,
          context,
          null,
            (dynamic) {
              initCheckConnection();
            },
        );
      });
    }
  }

  Future<void> _handleLaunchFromNotification(String token, DataSessionUtil sessionUtil) async {
    final launchDetails = await _notificationsPlugin.getNotificationAppLaunchDetails();
    final openedFromNotification = launchDetails?.didNotificationLaunchApp ?? false;
    if (!openedFromNotification) {
      Get.offAllNamed('/home');
      return;
    }
    final sessionId = await sessionUtil.getCurrentChatSessionId();
    if (sessionId == null) {
      Get.offAllNamed('/home');
      return;
    }
    try {
      final repository = ChatApiRepository();
      final sessions = await repository.getChatSessions(token);
      final ChatSession session = sessions.firstWhere(
            (e) => e.id == sessionId,
      );
      Get.offAllNamed('/chat', arguments: session);
    } catch (e) {
      Get.offAllNamed('/home');
    }
  }
}