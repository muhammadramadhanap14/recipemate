import 'package:shared_preferences/shared_preferences.dart';

class DataSessionUtil {
  // Key
  static const String _fingerprintKey = 'fingerprint_enabled';
  static const String _profileImagePathKey = 'profile_image_path';

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
