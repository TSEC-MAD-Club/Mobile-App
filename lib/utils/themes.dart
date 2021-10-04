import 'package:flutter/material.dart';

// Light mode colors
const kLightModeDarkBlue = Color(0xFF136ABF);
const kLightModeLightBlue = Color(0xFF297DCF);

// Dark mode colors
const kDarkModeDarkBlue = Color(0xFF297DCF);
const kDarkModeLightBlue = Color(0xFF4391DE);

// Common colors
const kDisabledBlue = Color(0x801265B5);
const kWhite = Color(0xFFE4E6EB);
const kBlack = Color(0xFF18191A);
const kLightBlack = Color(0xFF242526);

late final theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF2F5F8),
  textButtonTheme: _getTextButtonTheme(
    darkColor: kLightModeDarkBlue,
    lightColor: kLightModeLightBlue,
  ),
  primaryColor: const Color(0xFFF2F5F8),
  textTheme: _textTheme.apply(
    bodyColor: kBlack,
    displayColor: kBlack,
  ),
  accentColor: Colors.white,
  fontFamily: "SF Pro Text",
);

late final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF18191A),
  primaryColor: const Color(0xFF242526),
  textButtonTheme: _getTextButtonTheme(
    darkColor: kDarkModeDarkBlue,
    lightColor: kDarkModeLightBlue,
  ),
  textTheme: _textTheme.apply(
    bodyColor: kWhite,
    displayColor: kWhite,
  ),
  accentColor: kLightBlack,
  fontFamily: "SF Pro Text",
);

const _textTheme = TextTheme(
  headline1: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),
  headline2: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  headline3: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  ),
  headline4: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  ),
  bodyText1: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
  bodyText2: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  ),
  caption: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
);

TextButtonThemeData _getTextButtonTheme({
  required Color darkColor,
  required Color lightColor,
}) {
  return TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 14, horizontal: 29),
      ),
      backgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.pressed))
          return darkColor;
        else if (states.contains(MaterialState.disabled))
          return kDisabledBlue;
        else if (states.contains(MaterialState.hovered))
          return Colors.transparent;
        else
          return lightColor;
      }),
      foregroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) return darkColor;
        return kWhite;
      }),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      side: MaterialStateBorderSide.resolveWith((states) {
        if (states.contains(MaterialState.pressed))
          return BorderSide(color: darkColor);
      }),
    ),
  );
}
