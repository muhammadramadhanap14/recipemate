import 'package:recipemate/l10n/app_localizations.dart';

class AuthValidator {
  static String? validateEmail(String? email, AppLocalizations l10n) {
    if (email == null || email.trim().isEmpty) {
      return l10n.stEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return l10n.stEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? password, AppLocalizations l10n, {bool isRegister = false}) {
    if (password == null || password.isEmpty) {
      return l10n.stPasswordRequired;
    }
    if (isRegister) {
      if (password.length < 8) {
        return l10n.stPasswordTooShort;
      }
      final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
      final hasNumber = RegExp(r'[0-9]').hasMatch(password);
      if (!hasLetter || !hasNumber) {
        return l10n.stPasswordRequirements;
      }
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword, AppLocalizations l10n) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return l10n.stConfirmPasswordRequired;
    }
    if (password != confirmPassword) {
      return l10n.stPasswordNotMatch;
    }
    return null;
  }
}
