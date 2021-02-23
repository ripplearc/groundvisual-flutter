import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/components/calendar_page.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/document/document_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';

class RootHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomePageState();
}

class _RootHomePageState extends State<RootHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    // LandingHomePage(),
    DocumentHomePage(),
    MyHomePage(title: "Fleet"),
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
      bottomNavigationBar: BottomNavigation(action: (index) {
        setState(() {
          _currentIndex = index;
        });
      }));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Show Material Dialog'),
              onPressed: _showMaterialDialog,
            ),
            RaisedButton(
              child: Text('Show Cupertino Dialog'),
              onPressed: _showCupertinoDialog,
            ),
          ],
        ),
      ),
    );
  }

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

  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("Cupertino Dialog"),
              content: new Text("Hey! I'm Coflutter!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
