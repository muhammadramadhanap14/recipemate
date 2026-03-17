import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    required String message,
    String? negativeTitle,
    String? positiveTitle,
    VoidCallback? onNegativeClick,
    VoidCallback? onPositiveClick,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              customText(
                text: message,
                textAlign: TextAlign.center,
                fontSize: DimensText.bodyText(context),
                fontWeight: FontWeight.w500,
                color: Theme.of(dialogContext).colorScheme.onSurface,
                intMaxLine: null,
              ),
              const SizedBox(height: 24),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            customOutlinedButton(
              onPressed: onNegativeClick ?? () => Navigator.of(dialogContext).pop(),
              text: negativeTitle ?? AppLocalizations.of(context)!.stCancelTitle,
              borderColor: Theme.of(dialogContext).colorScheme.outline,
              fontColor: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              fontSize: DimensText.buttonSmallText(context),
            ),
            customRawMaterialButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (onPositiveClick != null) onPositiveClick();
              },
              text: positiveTitle ?? AppLocalizations.of(context)!.confirmLogout,
              fontColor: Theme.of(dialogContext).colorScheme.onPrimary,
              backgroundColor: Theme.of(dialogContext).colorScheme.primary,
              fontSize: DimensText.buttonSmallText(context),
              douWidth: 100,
              douHeight: 40,
            ),
          ],
        );
      },
    );
  }

}