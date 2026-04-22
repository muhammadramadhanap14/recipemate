import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataSessionUtil {
  // Key
  static const String _fingerprintKey = 'fingerprint_enabled';
  static const String _profileImagePathKey = 'profile_image_path';
  static const String _tokenKey = 'auth_token';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';
  static const String _lastFingerprintReminderKey = 'last_fingerprint_reminder';
  static const String _lastLanguageKey = 'last_language';
  static const String _lastThemeKey = 'last_theme';
  static const String _lastLoginTimestampKey = 'last_login_timestamp';
  static const String _notificationHistoryKey = 'notification_history';

  Future<void> setFingerprint(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fingerprintKey, value);
  }

  Future<bool> getFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fingerprintKey) ?? false;
  }

  Future<void> setLastFingerprintReminder(int timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastFingerprintReminderKey, timestamp);
  }

  Future<int?> getLastFingerprintReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastFingerprintReminderKey);
  }

  Future<void> setLastLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLanguageKey, languageCode);
  }

  Future<String?> getLastLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastLanguageKey);
  }

  Future<void> setLastTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastThemeKey, themeMode);
  }

  Future<String?> getLastTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastThemeKey);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setFullName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, name);
  }

  Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password);
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  Future<void> setProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagePathKey, path);
  }

  Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagePathKey);
  }

  Future<void> clearProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImagePathKey);
  }

  Future<void> setLastLoginTimestamp(int timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastLoginTimestampKey, timestamp);
  }

  Future<int?> getLastLoginTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastLoginTimestampKey);
  }

  Future<void> addNotificationToHistory(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_notificationHistoryKey) ?? [];
    final notification = {
      'title': title,
      'body': body,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    history.insert(0, jsonEncode(notification));
    if (history.length > 50) history = history.sublist(0, 50);
    await prefs.setStringList(_notificationHistoryKey, history);
  }

  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_notificationHistoryKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> saveNotificationHistory(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedList = list.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_notificationHistoryKey, encodedList);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear user specific data but keep theme and language
    await prefs.remove(_tokenKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_profileImagePathKey);
    await prefs.remove(_fingerprintKey);
    await prefs.remove(_lastFingerprintReminderKey);
    await prefs.remove(_lastLanguageKey);
    await prefs.remove(_lastThemeKey);
    await prefs.remove(_lastLoginTimestampKey);
    await prefs.remove(_notificationHistoryKey);
  }
}