import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/calendar_page.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';

class RootHomeMobilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomeMobilePageState();
}

class _RootHomeMobilePageState extends State<RootHomeMobilePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LandingHomePage(),
    DocumentHomePage(title: "Fleet"),
    PlaceholderWidget(
      "Fleet Page Under Construction",
      tab: SelectedTab.fleet,
    ),
    PlaceholderWidget(
      "Account Page Under Construction",
      tab: SelectedTab.account,
    )
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigation(action: _setCurrentIndex));

  void _setCurrentIndex(int index) => setState(() {
        _currentIndex = index;
      });
}

class DocumentHomePage extends StatefulWidget {
  DocumentHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DocumentHomePageState createState() => _DocumentHomePageState();
}

class _DocumentHomePageState extends State<DocumentHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: RaisedButton(
            child: Text('Show Calendar Dialog'),
            onPressed: _showMaterialDialog,
          ),
        ),
      );

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              backgroundColor: Theme.of(context).cardTheme.color,
              children: [
                _calenderSelection(ctx, Date.startOfToday, (DateTime t) {})
              ],
            ));
  }

  Widget _calenderSelection(
    BuildContext context,
    DateTime initialSelectedDate,
    Function(DateTime t) action,
  ) =>
      Container(
        height: 600,
        width: 500,
        child: CalendarPage(
            confirmSelectedDateAction: action,
            initialSelectedDate: initialSelectedDate),
      );
}
