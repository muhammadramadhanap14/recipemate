import 'package:shared_preferences/shared_preferences.dart';

class DataSessionUtil {
  // Key
  static const String _fingerprintKey = 'fingerprint_enabled';
  static const String _profileImagePathKey = 'profile_image_path';
  static const String _stToken = 'st_token';
  static const String _stFullName = 'st_full_name';
  static const String _stEmail = 'st_email';

  // --- EMAIL

  // Setter
  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stEmail, email);
  }

  // Getter
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stEmail);
  }

  // --- NAME

  // Setter
  Future<void> setFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stFullName, fullName);
  }

  // Getter
  Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stFullName);
  }

  // --- TOKEN

  // Setter
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stToken, token);
  }

  // Getter
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stToken);
  }

  // --- FINGERPRINT
  
  // Setter
  Future<void> setFingerprint(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fingerprintKey, value);
  }

  // Getter
  Future<bool> getFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fingerprintKey) ?? false;
  }

  // --- PROFILE IMAGE

  // Setter
  Future<void> setProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagePathKey, path);
  }

  // Getter
  Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagePathKey);
  }

  // Menghapus path gambar
  Future<void> clearProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImagePathKey);
  }
}