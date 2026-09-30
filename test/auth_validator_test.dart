import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/auth_validator.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('AuthValidator Tests', () {
    test('validateEmail returns error when empty', () {
      expect(AuthValidator.validateEmail('', l10n), isNotNull);
      expect(AuthValidator.validateEmail(null, l10n), isNotNull);
    });

    test('validateEmail returns error when invalid format', () {
      expect(AuthValidator.validateEmail('invalidemail', l10n), isNotNull);
      expect(AuthValidator.validateEmail('test@domain', l10n), isNotNull);
    });

    test('validateEmail returns null when valid', () {
      expect(AuthValidator.validateEmail('test@example.com', l10n), isNull);
    });

    test('validatePassword returns error when empty', () {
      expect(AuthValidator.validatePassword('', l10n, isRegister: true), isNotNull);
    });

    test('validatePassword returns error when too short for register', () {
      expect(AuthValidator.validatePassword('12345', l10n, isRegister: true), isNotNull);
    });

    test('validatePassword returns error when missing letters or numbers for register', () {
      expect(AuthValidator.validatePassword('abcdefgh', l10n, isRegister: true), isNotNull);
      expect(AuthValidator.validatePassword('12345678', l10n, isRegister: true), isNotNull);
    });

    test('validatePassword returns null when valid for register', () {
      expect(AuthValidator.validatePassword('password123', l10n, isRegister: true), isNull);
    });

    test('validateConfirmPassword returns error when mismatch', () {
      expect(AuthValidator.validateConfirmPassword('password123', 'wrongpassword', l10n), isNotNull);
    });

    test('validateConfirmPassword returns null when match', () {
      expect(AuthValidator.validateConfirmPassword('password123', 'password123', l10n), isNull);
    });
  });
}
