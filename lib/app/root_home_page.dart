import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';

class RootHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomePageState();
}

class _RootHomePageState extends State<RootHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LandingHomePage(),
    PlaceholderWidget(
      "Fleet Page Under Construction",
      tab: SelectedTab.fleet,
    ),
    PlaceholderWidget(
      "Document Page Under Construction",
      tab: SelectedTab.doc,
    ),
    PlaceholderWidget(
      "Account Page Under Construction",
      tab: SelectedTab.account,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigation(action: (index) {
          setState(() {
            _currentIndex = index;
          });
        }));
  }
}
