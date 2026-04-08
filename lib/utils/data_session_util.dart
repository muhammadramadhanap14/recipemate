import 'package:shared_preferences/shared_preferences.dart';

class DataSessionUtil {
  // Key
  static const String _fingerprintKey = 'fingerprint_enabled';
  static const String _profileImagePathKey = 'profile_image_path';
  static const String _tokenKey = 'auth_token';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  Future<void> setFingerprint(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fingerprintKey, value);
  }

  Future<bool> getFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fingerprintKey) ?? false;
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
}