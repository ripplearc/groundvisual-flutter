import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/app/mobile/root_home_mobile_page.dart';
import 'package:groundvisual_flutter/app/tablet/root_home_tablet_page.dart';
import 'package:groundvisual_flutter/component/theme/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GroundVisualApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Ground Visual',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: ScreenTypeLayout.builder(
          mobile: (_) => RootHomeMobilePage(),
          tablet: (_) => RootHomeTabletPage(),
          desktop: (_) => RootHomeTabletPage()));
}
