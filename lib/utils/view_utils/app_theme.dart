import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../color_var.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: HexColor(ColorVar.appColor),
      onPrimary: HexColor(ColorVar.white),
      secondary: HexColor(ColorVar.appColor),
      surface: HexColor(ColorVar.white),
      onSurface: HexColor(ColorVar.black),
      error: HexColor(ColorVar.red),
      onError: HexColor(ColorVar.white),
      onSecondary: HexColor(ColorVar.bgGray8),
      onTertiary: HexColor(ColorVar.black)


    ),

    scaffoldBackgroundColor: HexColor(ColorVar.white),
    cardColor: HexColor(ColorVar.widgetOrCardBgColor).withValues(alpha: 0.5),

    appBarTheme: AppBarTheme(
      backgroundColor: HexColor(ColorVar.white),
      foregroundColor: HexColor(ColorVar.black),
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: HexColor(ColorVar.appColor),
      onPrimary: HexColor(ColorVar.white),
      secondary: HexColor(ColorVar.appColor),
      surface: HexColor(ColorVar.bgGray8),
      onSurface: HexColor(ColorVar.white),
      error: HexColor(ColorVar.red),
      onError: HexColor(ColorVar.white),
      onSecondary: HexColor(ColorVar.bgGray8),
      onTertiary: HexColor(ColorVar.black)
    ),

    scaffoldBackgroundColor: HexColor(ColorVar.black),
    cardColor: HexColor(ColorVar.widgetOrCardBgColor).withValues(alpha: 0.18),

    appBarTheme: AppBarTheme(
      backgroundColor: HexColor(ColorVar.black),
      foregroundColor: HexColor(ColorVar.white),
      elevation: 0,
    ),
  );
}