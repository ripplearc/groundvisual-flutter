import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/components/theme/app_theme.dart';
import 'package:groundvisual_flutter/app/home_page.dart';

class GroundVisualApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Visual',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomePage(),
      // onGenerateRoute: Application.router.generator,
    );
  }
}
