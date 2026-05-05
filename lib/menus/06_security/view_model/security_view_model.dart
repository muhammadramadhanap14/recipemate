import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recipemate/l10n/app_localizations.dart';

import '../../../utils/constant_var.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class SecurityViewModel extends GetxController {
  final DataSessionUtilController session;
  final fullName = ''.obs;
  final emailId = ''.obs;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  SecurityViewModel({
    required this.session
  });

  @override
  void onInit() {
    super.onInit();
    _initBiometric();
    getUserFullName();
    getUserEmail();
    _startConnectivityListener();
    checkInitialConnection();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _startConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      checkInitialConnection();
    });
  }

  Future<void> checkInitialConnection() async {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    final context = Get.context;
    if (context != null) {
      _isDialogShowing = true;
      ViewDialogUtil().showOneButtonActionDialog(
        AppLocalizations.of(context)!.stNoConnectionMessage,
        AppLocalizations.of(context)!.backBtnTitle,
        ConstantVar.noConnectionGif,
        context,
        null,
            (dynamic val) {
          _isDialogShowing = false;
          checkInitialConnection();
        },
      );
    }
  }

  Future<void> getUserFullName() async {
    await session.loadFullName();
    fullName.value = session.stFullName.value;
  }

  Future<void> getUserEmail() async {
    await session.loadEmail();
    emailId.value = session.stEmail.value;
  }

  Future<void> _initBiometric() async {
    await _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      final available = await auth.getAvailableBiometrics();
      _canCheckBiometrics = canCheck && (available.contains(BiometricType.strong) || available.contains(BiometricType.fingerprint));
    } catch (e) {
      _canCheckBiometrics = false;
    }
  }

  Future<void> toggleFingerprint(bool value) async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (!_canCheckBiometrics) {
      AppSnackbar.show(
        title: l10n.stError,
        message: l10n.stDontHaveBiometric
      );
      return;
    }
    if (value) {
      try {
        final authenticated = await auth.authenticate(
          localizedReason: l10n.stEnableFingerprint,
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (authenticated) {
          await session.setFingerprint(true);
          AppSnackbar.show(
            title: l10n.stSuccess,
            message: l10n.stFingerprintSuccess
          );
        } else {
          AppSnackbar.show(
            title: l10n.stFailed,
            message: l10n.stFingerprintFailed
          );
        }
      } catch (e) {
        AppSnackbar.show(
          title: l10n.stError,
          message: "${l10n.stFingerprintError} $e"
        );
      }
    } else {
      await session.setFingerprint(false);
      AppSnackbar.show(
        title: l10n.stInfo,
        message: l10n.stFingerprintInfo
      );
    }
  }

  void openChangePasswordDialog (BuildContext context) {
    ViewDialogUtil().dialogChangePassword(
      context: context,
      onConfirm: (oldPassword, newPassword) {
        //TODO Fungsi untuk mengubah kata sandi
      }
    );
  }
}