import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/app/root_home_page.dart';
import 'package:groundvisual_flutter/components/theme/app_theme.dart';
import 'package:groundvisual_flutter/landing/body/landing_page_body.dart';

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

// class GroundVisualApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Google Maps Demo',
//       home: MapSample(),
//     );
//   }
// }
