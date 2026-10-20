import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/data_session_util_controller.dart';
import '../dimens_text.dart';

class ViewDialogUtil {
  static bool _isReloginDialogShowing = false;

  static void showReloginDialog(BuildContext context) {
    if (_isReloginDialogShowing) return;
    _isReloginDialogShowing = true;

    final l10n = AppLocalizations.of(context)!;
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;
    final sessionController = Get.find<DataSessionUtilController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
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
                    SizedBox(height: screenH * 0.04),
                    SizedBox(
                      width: double.infinity,
                      child: customElevatedButton(
                        onPressed: () async {
                          _isReloginDialogShowing = false;
                          await sessionController.logout();
                          Get.offAllNamed('/login');
                        },
                        text: l10n.stLoginAgainBtn,
                        backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                        fontColor: Theme.of(dialogContext).colorScheme.onPrimary,
                        borderRadius: screenW * 0.03,
                        fontSize: DimensText.buttonSmallText(context),
                        padding: EdgeInsets.symmetric(vertical: screenH * 0.015),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  static Future<void> showTrackingBottomSheet(
      BuildContext context, {
        required Widget icon,
        required String title,
        required InlineSpan message,
        required String positiveText,
        required String negativeText,
        required VoidCallback onPositiveClick,
        VoidCallback? onNegativeClick,
      }) async {
    RecipeMateAppUtil.init(context);
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;
    final colorScheme = Theme.of(context).colorScheme;
    final primaryGreen = const Color(0xFF5B8C3E);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: screenW * 0.05,
            right: screenW * 0.05,
            bottom: MediaQuery.of(context).viewInsets.bottom + screenH * 0.03,
          ),
          child: GlassCard(
            padding: EdgeInsets.all(screenW * 0.05),
            shape: LiquidRoundedRectangle(borderRadius: screenW * 0.06),
            settings: LiquidGlassSettings(
              glassColor: Theme.of(context).cardColor,
              backerColor: Colors.black.withValues(alpha: 0.05),
              thickness: 100,
              blur: 8,
              chromaticAberration: 0.4,
              lightIntensity: 1.2,
              refractiveIndex: 1.68,
              ambientRim: 0.3,
              edgeAbsorption: 0.12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: icon),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: DimensText.headerMenusText(context),
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenH * 0.02),
                Text.rich(
                  message,
                  style: TextStyle(
                    fontSize: DimensText.bodyText(context),
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: screenH * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onNegativeClick != null) {
                            onNegativeClick();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          negativeText,
                          style: TextStyle(
                            fontSize: DimensText.bodySmallText(context),
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onPositiveClick();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          positiveText,
                          style: TextStyle(
                            fontSize: DimensText.bodySmallText(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
