import 'package:flutter/material.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../dimens_text.dart';

class NoDataUtil extends StatelessWidget {
  const NoDataUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            customText(
              text: AppLocalizations.of(context)!.stNoDataFound,
              fontSize: DimensText.headerText(context),
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              intMaxLine: null,
            ),
            const SizedBox(height: 8),
            customText(
              text: AppLocalizations.of(context)!.stNoDataFoundMessage,
              fontSize: DimensText.captionText(context),
              color: Theme.of(context).colorScheme.onSurface,
              textAlign: TextAlign.center,
              intMaxLine: null,
            ),
          ],
        ),
      ),
    );
  }
}