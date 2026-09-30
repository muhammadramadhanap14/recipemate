import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/auth_route_resolver.dart';
import 'package:recipemate/utils/data_session_util_controller.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';

class EmailVerificationViewModel extends GetxController with WidgetsBindingObserver {
  final DataSessionUtilController sessionController = Get.find<DataSessionUtilController>();
  final FirebaseAuthService authService = Get.find<FirebaseAuthService>();

  final isLoading = false.obs;
  final resendCooldown = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkVerification();
    }
  }

  Future<void> checkVerification() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null && refreshedUser.emailVerified) {
          await refreshedUser.getIdToken(true);
          await sessionController.onUserLoggedIn();
          final route = await AuthRouteResolver.resolveRoute(refreshedUser);
          AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
          Get.offAllNamed(route);
          return;
        }
      }
      AppSnackbar.show(title: l10n.stInfo, message: l10n.stEmailNotVerifiedYet);
    } catch (e) {
      AppSnackbar.show(title: l10n.stError, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendEmail() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (resendCooldown.value > 0 || isLoading.value) return;
    try {
      await authService.sendEmailVerification();
      AppSnackbar.show(title: l10n.stSuccess, message: l10n.stEmailVerificationSent);
      resendCooldown.value = 60;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendCooldown.value > 0) {
          resendCooldown.value--;
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      AppSnackbar.show(title: l10n.stError, message: e.toString());
    }
  }

  Future<void> signOut() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    try {
      await authService.signOut();
      await sessionController.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      AppSnackbar.show(title: l10n.stError, message: e.toString());
    }
  }
}
