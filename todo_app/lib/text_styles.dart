import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';

class AppTextStyles {
  static const String _fontFamilyBebas = 'BebasNeue';
  static const String _fontFamilyMontserratRegular = 'Montserrat-Regular';
  static const String _fontFamilyMontserratSemiBold = 'Montserrat-SemiBold';

  static TextStyle headline1 = const TextStyle(
    fontFamily: _fontFamilyBebas,
    fontSize: 36,
    color: AppColors.coral,
  );

  static TextStyle headline2(Color color) {
    return TextStyle(
      fontFamily: _fontFamilyBebas,
      fontSize: 26,
      color: color, // Pass text color here
    );
  }

  static TextStyle headline3(Color color) {
    return TextStyle(
      fontFamily: _fontFamilyMontserratSemiBold,
      fontSize: 20,
      color: color,
    );
  }

  static TextStyle headline5 = const TextStyle(
    fontFamily: _fontFamilyMontserratSemiBold,
    fontSize: 20,
    color: Colors.white,
  );

  static TextStyle headline6 = const TextStyle(
    fontFamily: _fontFamilyMontserratSemiBold,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle headline7(Color color) {
    return TextStyle(
      fontFamily: _fontFamilyMontserratSemiBold,
      fontSize: 16,
      color: color,
    );
  }

  static TextStyle body1(Color color) {
    return TextStyle(
      fontFamily: _fontFamilyMontserratRegular,
      fontSize: 16,
      color: color,
    );
  }

  static TextStyle body2 = const TextStyle(
    fontFamily: _fontFamilyMontserratRegular,
    fontSize: 14,
    // color: Colors.white,
  );

  static TextStyle small = const TextStyle(
    fontFamily: _fontFamilyMontserratRegular,
    fontSize: 12,
    color: Colors.white,
  );

  static TextStyle button(Color color) {
    return TextStyle(
        fontFamily: _fontFamilyMontserratRegular,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: color);
  }
}
