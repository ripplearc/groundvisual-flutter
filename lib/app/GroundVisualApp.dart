import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';

class GroundVisualApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Visual',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LandingHomePage(),
    );
  }
}

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: Colors.white,
        onPrimary: Colors.white,
        primaryVariant: Colors.white38,
        secondary: Colors.red,
        onBackground: Colors.white),
    cardTheme: CardTheme(
      color: Colors.teal,
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
      color: Colors.amberAccent,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: Colors.orangeAccent,
        onPrimary: Colors.black87,
        primaryVariant: Colors.deepOrangeAccent,
        secondary: Colors.yellowAccent,
        background: Colors.black87,
        onBackground: Colors.white,
        surface: Colors.white30,
        onSurface: Colors.white60),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: Typography.material2018().white,
  );
}
