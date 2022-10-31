import 'package:flutter/material.dart';

ThemeData get appTheme {
  return ThemeData(
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    hintColor: Colors.white,
    dividerColor: Colors.white,
    buttonColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: AppColors.canvas,
    fontFamily: AppTheme.fontFamily,
  );
}

class AppColors {
  static const Color primary = Color(0xff93C01F);
  static const Color accent = Color(0xff009EE2);
  static const Color canvas = Colors.white;
  static const Color textColor = Color(0xff75838E);
  static const Color backgroundColor = Color(0xffEFEFEF);
  static const Color grey = Color(0xffDDDDDD);
  static Color warning = Colors.yellow[700];
  static const Color error = Color(0xffff6961);
}

class AppTheme {
  static const String fontFamily = "Gotham";
}
