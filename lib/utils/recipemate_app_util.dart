import 'dart:io';
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

  //change date format
  String reformatDateString(
      String dateString, String inputFormat, String outputFormat) {
    try{
      final DateFormat inputFormatter = DateFormat(inputFormat);
      final DateFormat outputFormatter = DateFormat(outputFormat);

      DateTime date = inputFormatter.parse(dateString);
      return outputFormatter.format(date);
    } catch (e) {
      return '';
    }
  }

  bool getCompareDate(String startDate, String endDate, String dateFormat) {
    try {
      DateFormat sdf = DateFormat(dateFormat);
      DateTime startDateTime = sdf.parse(startDate);
      DateTime endDateTime = sdf.parse(endDate);

      if (startDateTime.isBefore(endDateTime) ||
          startDateTime.isAtSameMomentAs(endDateTime)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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

}