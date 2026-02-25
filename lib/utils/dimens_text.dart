import 'package:flutter/cupertino.dart';

//class untuk menseragamkan font size
class DimensText {

  /// superHeader = 10% width (sebagai acuan utama)
  static double superHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.10;
  }

  /// Header utama (90% dari superHeader)
  static double mediumHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.09;
  }

  /// Header section utama
  static double headerText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.065;
  }

  /// Sub header besar
  static double subHeaderLargeText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.055;
  }

  /// Sub header normal
  static double subHeaderText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.048;
  }

  /// Text menu / title card
  static double headerMenusText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.042;
  }

  /// Text utama body (default reading text)
  static double bodyText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.038;
  }

  /// Text sekunder / description
  static double bodySmallText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.034;
  }

  /// Text caption / hint / label kecil
  static double captionText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.030;
  }

  /// Text sangat kecil (helper text)
  static double microText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.026;
  }

  /// Button utama (Sign In, Submit, dll)
  static double buttonText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.045;
  }

  static double buttonMediumText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.040;
  }

  static double buttonSmallText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }

  static double buttonMicroText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.030;
  }

  /// Account name / profile name
  static double accountNameText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.050;
  }

  static double accountInfoText(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.040;
  }
}