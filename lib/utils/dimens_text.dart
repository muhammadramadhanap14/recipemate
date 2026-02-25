import 'package:flutter/cupertino.dart';

//class untuk menseragamkan font size
class DimensText {

  static double superHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.07;
  }

  static double mediumHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.062;
  }

  static double headerText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.051;
  }

  static double subHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }

  static double headerMenusText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.042;
  }

  static double buttonText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.045;
  }

  static double miniButtonText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.038;
  }

  static double microButtonText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.028;
  }

  static double subHeaderTextAccount(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.040;
  }
}