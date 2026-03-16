
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../color_var.dart';

Widget customTextFormField({
  String? hintText,
  TextEditingController? controller,
  Icon? prefixIcon,
  TextInputType keyboardType = TextInputType.text,
  bool isEnable = true,
  bool readOnly = false,
  int intMaxLength = 25,
  int intMaxLine = 1,
  double doubleTextSize = 16.0,
  double doubleVerticalPadding = 10.0,
  double doubleHorizontalPadding = 10.0,
  String? value,
  String fontFamily = 'Poppins-Regular',
  String enableTextColor = '#FF000000', // Default to opaque black
  String disableTextColor = '#828282',
  String disableFillColor = '#FFFFFFFF',
  String enableFillColor = '#F2F2F2',
  bool isBorderSide = true,
  String? lblText,
  String? errorText,
  TextAlign? textAlign,
  TextInputAction? textInputAction,
  void Function(String)? onFieldSubmitted,
  required BuildContext context,
  void Function(String)? onChanged,
  void Function()? onSuffixClick,
  Icon? suffixIcon,
  bool isSuffixIcon = false,
  bool obscureText = false,
  required FocusNode focusNode,
}) {
  return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: TextFormField(
        initialValue: controller == null ? value : null,
        readOnly: readOnly,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        maxLength: intMaxLength,
        maxLines: intMaxLine,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        textAlign: textAlign ?? TextAlign.start,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: doubleTextSize == 0.0 ? 16.0 : doubleTextSize, // Fallback to 16.0 if 0.0
          color: isEnable ? HexColor(enableTextColor) : HexColor(disableTextColor), // Fallback to opaque black
          fontFamily: fontFamily,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: lblText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: !isSuffixIcon ? null
              : IconButton(
              onPressed: onSuffixClick,
              icon: suffixIcon!)  ,
          contentPadding: EdgeInsets.symmetric(vertical: doubleVerticalPadding,
              horizontal: doubleHorizontalPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: isBorderSide
                ? BorderSide(color: HexColor(ColorVar.bgGray8))
                : BorderSide.none,
          ),
          filled: true,
          counterText: '',
          fillColor: isEnable ? HexColor(enableFillColor) : HexColor(disableFillColor),
        ),
      )
  );
}

Widget customTextField(
    {Icon? prefixIcon,
      String? hintText,
      double borderRadius = 10.0,
      TextEditingController? controller,
      Icon? suffixIcon,
      bool isSuffixIcon = false,
      void Function()? onSuffixClick,
      required BuildContext context,
      required void Function(String) onChanged}) {
  return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: !isSuffixIcon ? null
                : IconButton(
                onPressed: onSuffixClick,
                icon: suffixIcon!),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onChanged: onChanged
      )
  );
}

Widget customText({
  required String text,
  double fontSize = 16,
  Color color = Colors.black,
  String fontFamily = 'Poppins-Regular',
  FontWeight? fontWeight,
  bool isSoftWrap = false,
  TextOverflow? textOverflow,
  int? intMaxLine = 1,
  TextAlign? textAlign,
  TextDecoration? decoration,
  Key? key,
}) {
  final bool isMultiline = intMaxLine == null || intMaxLine > 1;
  return Text(
    text,
    key: key,
    softWrap: isMultiline ? true : isSoftWrap,
    maxLines: intMaxLine,
    overflow: textOverflow ?? (isMultiline ? TextOverflow.visible : TextOverflow.ellipsis),
    textAlign: textAlign ?? TextAlign.left,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      decoration: decoration,
    ),
    textScaler: TextScaler.noScaling,
  );
}

Widget customOutlinedButton(
    {required void Function() onPressed,
      Color backgroundColor = Colors.white,
      double borderRadius = 10.0,
      Color borderColor = Colors.white,
      double borderWidth = 1,
      required String text,
      double fontSize = 16,
      String fontFamily = 'inter_regular',
      Color fontColor = Colors.white,
      FontWeight? fontWeight
    }) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      side: BorderSide(color: borderColor, width: borderWidth),
    ),
    child: Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          color: fontColor,
          fontWeight: fontWeight),
      textScaler: TextScaler.noScaling,
    ),
  );
}

Widget customRawMaterialButton({
  required void Function()? onPressed,
  Color backgroundColor = Colors.white,
  double borderRadius = 10.0,
  required String text,
  double fontSize = 16,
  String fontFamily = 'inter_regular',
  Color fontColor = Colors.white,
  FontWeight? fontWeight,
  required double douWidth,
  required double douHeight,
  EdgeInsetsGeometry padding = const EdgeInsets.all(0),
}) {
  return SizedBox(
    width: douWidth,
    height: douHeight,
    child: RawMaterialButton(
      onPressed: onPressed,
      fillColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: fontWeight),
      ),
    ),
  );
}

Widget customElevatedButton(
    {required void Function()? onPressed,
      Icon? icon,
      Color backgroundColor = Colors.white,
      Color foregroundColor = Colors.white,
      double borderRadius = 10.0,
      required String text,
      double fontSize = 16,
      String fontFamily = 'inter_regular',
      Color fontColor = Colors.white,
      Color? sideColor,
      FontWeight? fontWeight,
      EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0)}) {
  Color sideColors = sideColor??backgroundColor;
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: icon,
    label: Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight),
    ),
    style: ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      // Text and icon color
      padding: padding,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
              color: sideColors)// Rounded corners
      ),
    ),
  );
}

Widget customIconButton({
  required IconData icon,
  required VoidCallback? onPressed,
  Color enabledColor = const Color(0xFFE91E63),   // PINK
  Color disabledColor = const Color(0xFFBDBDBD),  // ABU2
  double size = 48.0,
  double iconSize = 28.0,
  double borderRadius = 16.0,
  double elevation = 6.0,
}) {
  final bool isEnabled = onPressed != null;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      splashColor: isEnabled
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.transparent,
      highlightColor: isEnabled
          ? Colors.white.withValues(alpha: 0.2)
          : Colors.transparent,
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isEnabled ? enabledColor : disabledColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    ),
  );
}

Widget customTextButton({
  Icon? icon,
  required String text,
  double fontSize = 16,
  String fontFamily = 'inter_regular',
  Color? fontColor,
  FontWeight? fontWeight,
  required void Function()? onPressed,
  Color? backgroundColor,
  TextDecoration? decoration,
}) {
  return TextButton.icon(
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
            fontFamily: fontFamily,
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
        ),
      )
  );
}