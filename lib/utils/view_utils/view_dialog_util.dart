import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../../models/model_response/login_response.dart';
import '../../repository/api_repository.dart';
import '../../utils/data_session_util_controller.dart';
import 'package:local_auth/local_auth.dart';
import '../constant_var.dart';
import '../dimens_text.dart';
import 'app_snackbar.dart';

class ViewDialogUtil {
  static bool _isReloginDialogShowing = false;

  static void showReloginDialog(BuildContext context) {
    if (_isReloginDialogShowing) return;
    _isReloginDialogShowing = true;

    final l10n = AppLocalizations.of(context)!;
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;
    final sessionController = Get.find<DataSessionUtilController>();
    final apiRepository = Get.find<ApiRepository>();

    final TextEditingController passwordController = TextEditingController();
    final FocusNode passwordFocusNode = FocusNode();
    final LocalAuthentication auth = LocalAuthentication();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;
        String errorMessage = '';

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> loginWithBiometric() async {
              try {
                final bool authenticated = await auth.authenticate(
                  localizedReason: l10n.stLoginFingerprint,
                  options: const AuthenticationOptions(
                    stickyAuth: true,
                    biometricOnly: true,
                  ),
                );

                if (authenticated) {
                  final savedEmail = sessionController.stEmail.value;
                  final savedPassword = await sessionController.getSavedPassword();

                  if (savedEmail.isNotEmpty && savedPassword != null) {
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });

                    final result = await apiRepository.postApiLogin(savedEmail, savedPassword);

                    if (result == null) {
                      setState(() {
                        errorMessage = l10n.stInternalServerError;
                        isLoading = false;
                      });
                      return;
                    }

                    final response = LoginResponse.fromJson(result);
                    if (response.status == ConstantVar.stSuccess && response.data?.token != null) {
                      await sessionController.setToken(response.data?.token ?? '');
                      await sessionController.onUserLoggedIn();
                      _isReloginDialogShowing = false;
                      Get.back();
                      AppSnackbar.show(title: l10n.stSuccess, message: response.message ?? l10n.stSuccess);
                    } else {
                      setState(() {
                        errorMessage = response.message ?? l10n.stFailedLogin;
                        isLoading = false;
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = l10n.stLoginFingerprintErrorMessage;
                    });
                  }
                }
              } catch (e) {
                setState(() {
                  errorMessage = e.toString();
                  isLoading = false;
                });
              }
            }

            return PopScope(
              canPop: false,
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.075,
                  vertical: screenH * 0.05,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenW * 0.85,
                  ),
                  child: GlassCard(
                    padding: EdgeInsets.all(screenW * 0.06),
                    shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenW * 0.030),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_reset_outlined,
                              color: Theme.of(dialogContext).colorScheme.primary,
                              size: screenW * 0.08,
                            ),
                          ),
                          SizedBox(height: screenH * 0.02),
                          customText(
                            text: l10n.stSessionExpiredTitle,
                            fontSize: DimensText.bodyText(context),
                            fontWeight: FontWeight.bold,
                            color: Theme.of(dialogContext).colorScheme.onSurface,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenH * 0.01),
                          customText(
                            text: l10n.stSessionExpiredMessage,
                            fontSize: DimensText.captionText(context),
                            fontWeight: FontWeight.w500,
                            color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                            textAlign: TextAlign.center,
                            intMaxLine: null,
                          ),
                          SizedBox(height: screenH * 0.03),
                          // Email Field (Readonly)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: l10n.stEmailAddress,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(dialogContext).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: screenH * 0.01),
                          customTextFormField(
                            context: context,
                            controller: TextEditingController(text: sessionController.stEmail.value),
                            focusNode: FocusNode(),
                            readOnly: true,
                            isEnable: true,
                            isSuffixIcon: false,
                            enableTextColor: Theme.of(dialogContext).colorScheme.onSurface.toHex(),
                            enableFillColor: Theme.of(dialogContext).cardColor.toHex(),
                            isBorderSide: false,
                          ),
                          SizedBox(height: screenH * 0.02),
                          // Password Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: l10n.stPassword,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(dialogContext).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: screenH * 0.01),
                          customTextFormField(
                            context: context,
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            isSuffixIcon: false,
                            hintText: "Password",
                            enableTextColor: Theme.of(dialogContext).colorScheme.onSurface.toHex(),
                            enableFillColor: Theme.of(dialogContext).cardColor.toHex(),
                            isBorderSide: false,
                          ),
                          if (errorMessage.isNotEmpty) ...[
                            SizedBox(height: screenH * 0.01),
                            customText(
                              text: errorMessage,
                              fontSize: DimensText.microText(context),
                              color: Theme.of(dialogContext).colorScheme.error,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: screenH * 0.04),
                          Row(
                            children: [
                              Expanded(
                                child: customElevatedButton(
                                  onPressed: isLoading ? null : () async {
                                    if (passwordController.text.isEmpty) {
                                      setState(() {
                                        errorMessage = "Password cannot be empty";
                                      });
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                      errorMessage = '';
                                    });

                                    try {
                                      final result = await apiRepository.postApiLogin(
                                        sessionController.stEmail.value,
                                        passwordController.text,
                                      );

                                      if (result == null) {
                                        setState(() {
                                          errorMessage = l10n.stInternalServerError;
                                          isLoading = false;
                                        });
                                        return;
                                      }

                                      final response = LoginResponse.fromJson(result);
                                      final isSuccess = response.status == ConstantVar.stSuccess;

                                      if (isSuccess && response.data?.token != null) {
                                        await sessionController.setToken(response.data?.token ?? '');
                                        await sessionController.setSavedPassword(passwordController.text);
                                        await sessionController.onUserLoggedIn();
                                        
                                        _isReloginDialogShowing = false;
                                        Get.back();
                                        
                                        AppSnackbar.show(
                                          title: l10n.stSuccess,
                                          message: response.message ?? l10n.stSuccess,
                                        );
                                      } else {
                                        setState(() {
                                          errorMessage = response.message ?? l10n.stFailedLogin;
                                          isLoading = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        errorMessage = e.toString();
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  text: isLoading ? "Logging in..." : l10n.stLoginAgainBtn,
                                  backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                                  fontColor: Theme.of(dialogContext).colorScheme.onPrimary,
                                  borderRadius: screenW * 0.03,
                                  fontSize: DimensText.buttonSmallText(context),
                                  padding: EdgeInsets.symmetric(vertical: screenH * 0.015),
                                ),
                              ),
                              if (sessionController.isFingerprintEnabled.value) ...[
                                SizedBox(width: screenW * 0.03),
                                customIconButton(
                                  icon: Icons.fingerprint,
                                  onPressed: isLoading ? null : () => loginWithBiometric(),
                                  enabledColor: Theme.of(dialogContext).colorScheme.primary,
                                  size: 48,
                                  iconSize: 30,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: screenH * 0.01),
                          customTextButton(
                            onPressed: () async {
                              _isReloginDialogShowing = false;
                              await sessionController.logout();
                              Get.offAllNamed('/login');
                            },
                            text: l10n.logout,
                            fontColor: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                            fontSize: DimensText.buttonSmallText(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog choose theme
  static Future<ThemeMode?> dialogSelectTheme(BuildContext context, ThemeMode currentTheme) {
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;

    return Get.dialog<ThemeMode>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: screenW * 0.075),
        child: GlassCard(
          padding: EdgeInsets.all(screenW * 0.05),
          shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: AppLocalizations.of(context)!.selectTheme,
                fontSize: DimensText.bodyText(context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: screenH * 0.01),
              RadioGroup<ThemeMode>(
                groupValue: currentTheme,
                onChanged: (ThemeMode? value) {
                  Get.back(result: value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      title: customText(
                        text: "Default System",
                        fontSize: DimensText.bodySmallText(context),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      value: ThemeMode.system,
                    ),
                    RadioListTile<ThemeMode>(
                      title: customText(
                        text: "Light",
                        fontSize: DimensText.bodySmallText(context),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      title: customText(
                        text: "Dark",
                        fontSize: DimensText.bodySmallText(context),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void dialogSelectLanguage({
    required BuildContext context,
    required Function(Locale? locale, String label) onSelected
  }) {
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: screenW * 0.075),
        child: GlassCard(
          padding: EdgeInsets.all(screenW * 0.05),
          shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: AppLocalizations.of(context)!.selectLanguage,
                fontSize: DimensText.bodyText(context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: screenH * 0.01),
              ListTile(
                title: customText(
                  text: "System Language",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  onSelected(null, "System");
                  Get.back();
                },
              ),
              ListTile(
                title: customText(
                  text: "English",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  onSelected(const Locale('en'), "English");
                  Get.back();
                },
              ),
              ListTile(
                title: customText(
                  text: "Bahasa Indonesia",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  onSelected(const Locale('id'), "Indonesia");
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    String? negativeTitle,
    String? positiveTitle,
    VoidCallback? onNegativeClick,
    VoidCallback? onPositiveClick,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final screenW = RecipeMateAppUtil.screenWidth;
        final screenH = RecipeMateAppUtil.screenHeight;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: screenW * 0.075),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenW * 0.75,
            ),
            child: GlassCard(
              padding: EdgeInsets.all(screenW * 0.05),
              shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(screenW * 0.030),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(dialogContext).colorScheme.primary,
                      size: screenW * 0.06,
                    ),
                  ),
                  SizedBox(height: screenH * 0.02),
                  customText(
                    text: title,
                    fontSize: DimensText.bodyText(context),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(dialogContext).colorScheme.onSurface,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenH * 0.01),
                  customText(
                    text: message,
                    fontSize: DimensText.captionText(context),
                    fontWeight: FontWeight.w500,
                    color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                    intMaxLine: null,
                  ),
                  SizedBox(height: screenH * 0.025),
                  SizedBox(
                    width: double.infinity,
                    child: customElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (onPositiveClick != null) onPositiveClick();
                      },
                      text: positiveTitle ?? AppLocalizations.of(context)!.confirmLogout,
                      backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                      fontColor: Theme.of(dialogContext).colorScheme.onPrimary,
                      borderRadius: screenW * 0.03,
                      fontSize: DimensText.buttonSmallText(context),
                      padding: EdgeInsets.symmetric(vertical: screenH * 0.015),
                    ),
                  ),
                  SizedBox(height: screenH * 0.005),
                  customTextButton(
                    onPressed: onNegativeClick ?? () => Navigator.of(dialogContext).pop(),
                    text: negativeTitle ?? AppLocalizations.of(context)!.stCancelTitle,
                    fontColor: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                    fontSize: DimensText.buttonSmallText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showOneButtonActionDialog(
      String content, String btnTitle,
      String pictureParam,BuildContext context,
      dynamic intentData,
      Function(dynamic model) onClick,
      ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          final screenWidth = MediaQuery.of(dialogContext).size.width;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.7,
              ),
              child: GlassCard(
                padding: const EdgeInsets.all(15.0),
                shape: LiquidRoundedRectangle(borderRadius: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/$pictureParam', width: 160, height: 110),
                    const SizedBox(height: 15),
                    customText(
                      text: content,
                      textAlign: TextAlign.center,
                      color: Theme.of(context).colorScheme.onTertiary,
                      isSoftWrap: true,
                      intMaxLine: null,
                      fontSize: DimensText.bodyText(context),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: customTextButton(
                          text: btnTitle,
                          fontColor: Theme.of(context).colorScheme.onTertiary,
                          fontSize: DimensText.buttonSmallText(context),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onClick(intentData);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}