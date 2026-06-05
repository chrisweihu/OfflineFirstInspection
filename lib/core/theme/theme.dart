import 'package:flutter/material.dart';
import 'package:offline_first_inspection/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.borderColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      );

  static final inputDecorationThemeData = InputDecorationTheme(
    border: _border(),
    contentPadding: const EdgeInsets.all(27),
    enabledBorder: _border(),
    focusedBorder: _border(AppPallete.gradient1),
    focusedErrorBorder: _border().copyWith(
      borderSide: const BorderSide(color: AppPallete.errorColor, width: 3),
    ),
    errorBorder: _border().copyWith(
      borderSide: const BorderSide(color: AppPallete.errorColor),
    ),
  );

  static final ThemeData darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),

    inputDecorationTheme: inputDecorationThemeData,

    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationThemeData.copyWith(
        contentPadding: const EdgeInsets.all(6),
      ),
    ),

    //textTheme: Typography.blackCupertino,
  );
}
