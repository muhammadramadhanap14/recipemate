import 'package:shared_preferences/shared_preferences.dart';

class DataSessionUtil {
  // Key
  static const String _fingerprintKey = 'fingerprint_enabled';

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
}