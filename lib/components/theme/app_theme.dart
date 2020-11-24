import 'package:flutter/material.dart';

/// AppTheme defines the color and font of the Ripple Design System (RDS)
/// including its behaviour in the light and dark mode
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.orangeAccent,
      ),
    ),
    bottomAppBarColor: Colors.grey[100],
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.grey[100],
    ),
    colorScheme: ColorScheme(
        primary: Colors.orangeAccent,
        primaryVariant: Colors.deepOrangeAccent,
        onPrimary: Colors.black,
        secondary: Colors.yellowAccent,
        secondaryVariant: Colors.yellow,
        onSecondary: Colors.black,
        background: Colors.white,
        onBackground: Colors.black54,
        surface: Colors.grey[100],
        onSurface: Colors.grey[500],
        error: Colors.red,
        onError: Colors.white,
        brightness: Brightness.light),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.black87,
      iconTheme: IconThemeData(
        color: Colors.orangeAccent,
      ),
    ),
    colorScheme: ColorScheme(
        primary: Colors.orangeAccent,
        onPrimary: Colors.black87,
        primaryVariant: Colors.deepOrangeAccent,
        secondary: Colors.yellowAccent,
        secondaryVariant: Colors.yellow,
        onSecondary: Colors.black87,
        background: Colors.black87,
        onBackground: Colors.white,
        surface: Colors.grey[850],
        onSurface: Colors.grey[600],
        error: Colors.red,
        onError: Colors.white,
        brightness: Brightness.dark),
    cardTheme: CardTheme(
      color: Colors.grey[850],
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: Typography.material2018().white,
  );
}
