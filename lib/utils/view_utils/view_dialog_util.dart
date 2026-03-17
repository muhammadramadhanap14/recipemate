import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../dimens_text.dart';

class ViewDialogUtil {

  // Dialog choose theme
  static Future<ThemeMode?> dialogSelectTheme(BuildContext context, ThemeMode currentTheme) {
    return Get.dialog<ThemeMode>(
      AlertDialog(
        title: customText(
          text: AppLocalizations.of(context)!.selectTheme,
          fontSize: DimensText.bodyText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface
        ),
        content: RadioGroup<ThemeMode>(
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
                  color: Theme.of(context).colorScheme.onSurface
                ),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: customText(
                  text: "Light",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface
                ),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: customText(
                  text: "Dark",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface
                ),
                value: ThemeMode.dark,
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
    Get.dialog(
      AlertDialog(
        title: customText(
          text: AppLocalizations.of(context)!.selectLanguage,
          fontSize: DimensText.bodyText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: customText(
                text: "System Language",
                fontSize: DimensText.bodySmallText(context),
                color: Theme.of(context).colorScheme.onSurface
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
                color: Theme.of(context).colorScheme.onSurface
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
                color: Theme.of(context).colorScheme.onSurface
              ),
              onTap: () {
                onSelected(const Locale('id'), "Indonesia");
                Get.back();
              },
            ),
          ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenW * 0.04),
          ),
          backgroundColor: Theme.of(dialogContext).scaffoldBackgroundColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenW * 0.75,
            ),
            child: Padding(
              padding: EdgeInsets.all(screenW * 0.05),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.all(15.0),
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
                          }),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}