import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RecipeMateAppUtil {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  //get current date time
  static String getCurrentDate(String dateFormat) {
    final DateTime now = DateTime.now();
    return DateFormat(dateFormat).format(now);
  }

  static Orientation initOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  // Fungsi untuk mengatur orientasi
  static Future<void> lockToPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //dapatkan device id
  static Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.name}:${androidDeviceInfo.id}';
    }
    return uniqueDeviceId;
  }

}