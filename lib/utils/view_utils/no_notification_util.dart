import 'package:flutter/material.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../dimens_text.dart';
import '../recipemate_app_util.dart';

class NoNotificationUtil extends StatelessWidget {
  const NoNotificationUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.08,
            vertical: RecipeMateAppUtil.screenHeight * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration Container
              Container(
                width: RecipeMateAppUtil.screenWidth * 0.35,
                height: RecipeMateAppUtil.screenWidth * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.notifications_off_rounded,
                  size: RecipeMateAppUtil.screenWidth * 0.16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

              // Title
              customText(
                text: AppLocalizations.of(context)!.stNoNotificationYet,
                fontSize: DimensText.headerMenusText(context),
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                intMaxLine: null,
                fontFamily: 'times_new_roman_bold',
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),

              // Description
              customText(
                text: AppLocalizations.of(context)!.stNoNotificationYetMessage,
                fontSize: DimensText.bodySmallText(context),
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                textAlign: TextAlign.center,
                intMaxLine: null,
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

              // Suggestion Text
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: RecipeMateAppUtil.screenWidth * 0.04,
                  vertical: RecipeMateAppUtil.screenHeight * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(
                    RecipeMateAppUtil.screenWidth * 0.03,
                  ),
                ),
                child: customText(
                  text: AppLocalizations.of(context)!.stCheckBackLater,
                  fontSize: DimensText.captionText(context),
                  color: Theme.of(context).colorScheme.primary,
                  textAlign: TextAlign.center,
                  intMaxLine: null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
