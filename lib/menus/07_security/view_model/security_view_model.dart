import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/data_session_util.dart';

import '../../../utils/view_utils/app_snackbar.dart';

class SecurityViewModel extends GetxController {
  final DataSessionUtil dataSessionUtil;
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@recipemate.io'.obs;
  final RxBool isFingerprintEnabled = false.obs;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  SecurityViewModel({
    required this.dataSessionUtil
  });

  @override
  void onInit() {
    super.onInit();
    _initBiometric();
  }

  Future<void> _initBiometric() async {
    await _checkBiometrics();
    await _loadBiometricStatus();
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

  Future<void> _loadBiometricStatus() async {
    isFingerprintEnabled.value = dataSessionUtil.getFingerprint();
  }

  Future<void> toggleFingerprint(bool value) async {
    final context = Get.context!;
    if (!_canCheckBiometrics) {
      AppSnackbar.show(
        title: AppLocalizations.of(context)!.stError,
        message: AppLocalizations.of(context)!.stDontHaveBiometric
      );
      return;
    }
    if (value) {
      try {
        final authenticated = await auth.authenticate(
          localizedReason: AppLocalizations.of(context)!.stEnableFingerprint,
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (authenticated) {
          isFingerprintEnabled.value = true;
          await dataSessionUtil.setFingerprint(true);
          AppSnackbar.show(
            title: AppLocalizations.of(context)!.stSuccess,
            message: AppLocalizations.of(context)!.stFingerprintSuccess
          );
        } else {
          isFingerprintEnabled.value = false;
          AppSnackbar.show(
            title: AppLocalizations.of(context)!.stFailed,
            message: AppLocalizations.of(context)!.stFingerprintFailed
          );
        }
      } catch (e) {
        isFingerprintEnabled.value = false;
        AppSnackbar.show(
          title: AppLocalizations.of(context)!.stError,
          message: AppLocalizations.of(context)!.stFingerprintError + e.toString()
        );
      }
    } else {
      isFingerprintEnabled.value = false;
      await dataSessionUtil.setFingerprint(true);
      AppSnackbar.show(
        title: AppLocalizations.of(context)!.stInfo,
        message: AppLocalizations.of(context)!.stFingerprintInfo
      );
    }
  }
}