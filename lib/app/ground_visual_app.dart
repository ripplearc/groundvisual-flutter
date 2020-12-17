import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/app/root_home_page.dart';
import 'package:groundvisual_flutter/components/theme/app_theme.dart';

class GroundVisualApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Visual',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: RootHomePage(),
    );
  }
}
