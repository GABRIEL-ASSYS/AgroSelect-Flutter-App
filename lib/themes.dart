import 'package:flutter/material.dart';

abstract class AppColors {
  static Color verde = Colors.green;
  static Color branco = Colors.white;
}

abstract class PrimaryButtonProperties {
  static double size = 300;

  static TextStyle textStyle = TextStyle(
    color: AppColors.branco,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static Color iconColor = AppColors.branco;

  static BoxDecoration boxDecoration = BoxDecoration(
    boxShadow: kElevationToShadow[6],
    borderRadius: BorderRadius.circular(30),
    color: AppColors.verde,
  );
}

abstract class SecundaryButtonProperties {
  static double size = 500;

  static TextStyle textStyle = TextStyle(
    color: AppColors.branco,
    fontSize: 35,
    fontWeight: FontWeight.w600,
  );

  static Color iconColor = AppColors.branco;

  static BoxDecoration boxDecoration = BoxDecoration(
    boxShadow: kElevationToShadow[6],
    borderRadius: BorderRadius.circular(30),
    color: AppColors.verde,
  );
}

abstract class FloatingButton {
  static double size = 60;

  static TextStyle textStyle = TextStyle(
    color: AppColors.branco,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static Color iconColor = AppColors.branco;

  static BoxDecoration boxDecoration = BoxDecoration(
    boxShadow: kElevationToShadow[6],
    borderRadius: BorderRadius.circular(16),
    color: AppColors.verde,
  );
}

abstract class AppBackground {
  static BoxDecoration boxDecoration = BoxDecoration(
    color: AppColors.branco,
  );
}

abstract class AppInputs {
  static TextStyle textDecoration = TextStyle(
    color: AppColors.verde,
    fontSize: 20
  );

  static InputDecoration newInputDecoration(String hintText, String labelText,
      [Icon? icon]) {
    return InputDecoration(
      prefixIcon: icon,
      prefixIconColor: AppColors.verde,
      hintStyle: TextStyle(
        color: AppColors.verde,
      ),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.verde,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.verde,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppColors.verde,
        fontSize: 30,
      ),
    );
  }
}