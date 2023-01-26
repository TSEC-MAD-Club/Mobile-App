import 'package:flutter/material.dart';

// Light mode colors
const kLightModeDarkBlue = Color(0xFF136ABF);
const kLightModeLightBlue = Color(0xFF297DCF);
const kLightModeToggleBtnBg = Color(0xFFD8D5D5);
const kLightModeShadowColor = Color(0x00D3D3D3);

// Dark mode colors
const kDarkModeDarkBlue = Color(0xFF297DCF);
const kDarkModeLightBlue = Color(0xFF4391DE);
const kDarkModeToggleBtnBg = Color(0xFF242526);
const kDarkModeShadowColor = Color(0x00A9A9A9);

//shadowsForBtn
const shadowDarkModeToggleBtn = [
  BoxShadow(
    color: Color(0x66000000),
    spreadRadius: 5,
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
];

const shadowLightModeToggleBtn = [
  BoxShadow(
    color: Color(0xFFd8d7da),
    spreadRadius: 5,
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
];

//shadowsForTextFields
const shadowDarkModeTextFields = [
  BoxShadow(
    color: Color(0x00A9A9A9),
    spreadRadius: 2,
    blurRadius: 1,
    offset: Offset(2, 2),
  ),
];
const shadowLightModeTextFields = [
  BoxShadow(
    color: Color(0x00D3D3D3),
    spreadRadius: 2,
    blurRadius: 1,
    offset: Offset(2, 2),
  ),
];
// Common colors
const kDisabledBlue = Color(0x801265B5);
const kWhite = Color(0xFFE4E6EB);
const kBlack = Color(0xFF18191A);
const kLightBlack = Color(0xFF242526);

late final theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF2F5F8),
  shadowColor: const Color(0x00D3D3D3),
  textButtonTheme: _getTextButtonTheme(
    darkColor: kLightModeDarkBlue,
    lightColor: kLightModeLightBlue,
  ),
  elevatedButtonTheme: _getElevatedButtonTheme(
    darkColor: kLightModeDarkBlue,
    lightColor: kLightModeDarkBlue,
  ),
  primaryColor: const Color(0xFFF2F5F8),
  primaryColorLight: const Color(0xFFF2F5F8),
  primaryColorDark: const Color(0xFFD8D5D5),
  textTheme: _textTheme.apply(
    bodyColor: kBlack,
    displayColor: kBlack,
  ),
  fontFamily: "SF Pro Text",
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
);

late final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF18191A),
  primaryColor: const Color(0xFF242526),
  primaryColorLight: const Color(0xFf34323d),
  primaryColorDark: const Color(0xFF000000),
  shadowColor: const Color(0x00A9A9A9),
  elevatedButtonTheme: _getElevatedButtonTheme(
    darkColor: kDarkModeDarkBlue,
    lightColor: kDarkModeLightBlue,
  ),
  textButtonTheme: _getTextButtonTheme(
    darkColor: kDarkModeDarkBlue,
    lightColor: kDarkModeLightBlue,
  ),
  textTheme: _textTheme.apply(
    bodyColor: kWhite,
    displayColor: kWhite,
  ),
  fontFamily: "SF Pro Text",
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kLightBlack),
);

var _textTheme = const TextTheme(
  titleLarge: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),
  titleMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  titleSmall: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  ),
  headlineLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  headlineSmall: TextStyle(),
  bodyMedium: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
  bodySmall: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  displayLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  labelLarge: TextStyle(),
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
        return null;
      }),
    ),
  );
}

ElevatedButtonThemeData _getElevatedButtonTheme({
  required Color darkColor,
  required Color lightColor,
}) {
  return ElevatedButtonThemeData(
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
        return null;
      }),
    ),
  );
}
