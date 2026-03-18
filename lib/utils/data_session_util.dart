import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSessionUtil extends GetxService {
  late SharedPreferences _prefs;

  Future<DataSessionUtil> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Key
  static const _keyFingerprint = 'fingerprint_enabled';

  // Setter
  Future<void> setFingerprint(bool value) async {
    await _prefs.setBool(_keyFingerprint, value);
  }

  // Getter
  bool getFingerprint() {
    return _prefs.getBool(_keyFingerprint) ?? false;
  }
}