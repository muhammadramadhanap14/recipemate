import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class GreetingUtil {
  static String getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return AppLocalizations.of(context)!.stMorningGreeting;
    } else if (hour < 18) {
      return AppLocalizations.of(context)!.stAfternoonGreeting;
    } else {
      return AppLocalizations.of(context)!.stEveningGreeting;
    }
  }
}