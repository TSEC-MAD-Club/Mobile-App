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

// late final theme = ThemeData(
//   scaffoldBackgroundColor: const Color(0xFFF2F5F8),
//   shadowColor: const Color(0x00D3D3D3),
//   textButtonTheme: _getTextButtonTheme(
//     darkColor: kLightModeDarkBlue,
//     lightColor: kLightModeLightBlue,
//   ),
//   elevatedButtonTheme: _getElevatedButtonTheme(
//     darkColor: kLightModeDarkBlue,
//     lightColor: kLightModeDarkBlue,
//   ),
//   primaryColor: const Color(0xFFF2F5F8),
//   primaryColorLight: const Color(0xFFF2F5F8),
//   primaryColorDark: const Color(0xFFD8D5D5),
//   cardColor: Colors.black87,
//   textTheme: _textTheme.apply(
//     bodyColor: kBlack,
//     displayColor: kBlack,
//   ),
//   fontFamily: "SF Pro Text",
//   colorScheme: ColorScheme.fromSwatch().copyWith(
//     secondary: Colors.white,
//     // onPrimary: Color.fromARGB(255, 78, 73, 73),
//     inversePrimary: Color.fromARGB(255, 241, 241, 241),
//     primaryContainer: Colors.white,
//     secondaryContainer: Color(0xff00C62C),
//     onSecondaryContainer: Colors.black,
//     outline: Color(0xFFE0E0E0),
//   ),
// );

late final darkTheme = ThemeData(
  fontFamily: "Inter",
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xffB2D0FF),
    primary: Color(0xffB2D0FF),
    background: Color(0xFF1B1B1B),
    onBackground: Color(0xff2A66FF),
    secondary: Color(0xff835983),
    outline: Color(0xff454545),
    secondaryContainer: Color(0xff5A5A5A),
    onPrimaryContainer: Color.fromARGB(255, 108, 108, 108),
    primaryContainer: Color(0xff323232),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    tertiary: Color(0xffF1F1F1),
    onTertiary: Color(0xff6B708C),
    // tertiaryContainer: Color(0xff1B1B1B),
    tertiaryContainer: Color(0xff2E9D5A),
    error: Color(0xffFF4D4D),
  ),
  scaffoldBackgroundColor: const Color(0xFF1B1B1B),
  // primaryColor: Color(0xffB2D0FF),
  // primaryColor: const Color(0xFF242526),
  // primaryColorLight: const Color(0xFf34323d),
  // primaryColorDark: const Color(0xFF000000),
  // shadowColor: const Color(0x00A9A9A9),
  // cardColor: Colors.white70,
  // elevatedButtonTheme: _getElevatedButtonTheme(
  //   darkColor: kDarkModeDarkBlue,
  //   lightColor: kDarkModeLightBlue,
  // ),
  // textButtonTheme: _getTextButtonTheme(
  //   darkColor: kDarkModeDarkBlue,
  //   lightColor: kDarkModeLightBlue,
  // ),
  textTheme: _textTheme.apply(
    bodyColor: kWhite,
    displayColor: kWhite,
  ),
  // colorScheme: ColorScheme.fromSwatch().copyWith(
  //   secondary: kLightBlack,
  //   // onPrimary: Color.fromARGB(255, 171, 171, 171),
  //   primaryContainer: Color(0xFF323232),
  //   secondaryContainer: Color(0xff00C62C),
  //   onSecondaryContainer: Colors.white,
  //   outline: Color(0xFF454545),
  //   inversePrimary: Color.fromARGB(255, 63, 63, 63),
  // ),
);

const _textTheme = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    fontFamily: "Priego",
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "Priego",
  ),
  headlineSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: "Priego",
  ),
  titleLarge: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    fontFamily: "Inter",
  ),
  titleMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "Inter",
  ),
  titleSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: "Inter",
  ),
  labelLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: "Inter",
  ),
  labelMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: "Inter",
  ),
  labelSmall: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontFamily: "Inter",
  ),
  bodySmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: "Inter",
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
        return null;
      }),
    ),
  );
}

getTextScale(BuildContext context) {
  return MediaQuery.of(context).copyWith(textScaleFactor: 1);
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
