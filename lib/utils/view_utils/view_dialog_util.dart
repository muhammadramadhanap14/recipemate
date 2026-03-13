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
        title: Text(
          "Select Theme",
          style: TextStyle(
            fontSize: DimensText.bodyText(context),
            fontWeight: FontWeight.bold,
          ),
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
                title: Text(
                  "System Default",
                  style: TextStyle(
                    fontSize: DimensText.bodySmallText(context),
                  ),
                ),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text(
                  "Light",
                  style: TextStyle(
                    fontSize: DimensText.bodySmallText(context),
                  ),
                ),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text(
                  "Dark",
                  style: TextStyle(
                    fontSize: DimensText.bodySmallText(context),
                  ),
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
        title: Text(
          AppLocalizations.of(context)!.selectLanguage,
          style: TextStyle(
            fontSize: DimensText.bodyText(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "System Language",
                style: TextStyle(
                  fontSize: DimensText.bodySmallText(context),
                ),
              ),
              onTap: () {
                onSelected(null, "System");
                Get.back();
              },
            ),
            ListTile(
              title: Text(
                "English",
                style: TextStyle(
                  fontSize: DimensText.bodySmallText(context),
                ),
              ),
              onTap: () {
                onSelected(const Locale('en'), "English");
                Get.back();
              },
            ),
            ListTile(
              title: Text(
                "Bahasa Indonesia",
                style: TextStyle(
                  fontSize: DimensText.bodySmallText(context),
                ),
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

  void showYesNoActionDialog(
    String content, String positiveTitle,
    String negativeTitle, String pictureParam,
    dynamic intentData,
    BuildContext context,
    Function(dynamic model) positiveClick,
  ){
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
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: customOutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: negativeTitle,
                        borderColor: Theme.of(context).colorScheme.onSecondary,
                        fontColor: Theme.of(context).colorScheme.onTertiary,
                        fontSize: DimensText.buttonSmallText(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: customRawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          positiveClick(intentData);
                        },
                        text: positiveTitle,
                        fontColor: Theme.of(context).colorScheme.onSurface,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fontSize: DimensText.buttonSmallText(context),
                        douWidth: 105,
                        douHeight: 40
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
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