import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/calendar_sheet.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/tablet/landing_page_tablet_header.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';

/// Tablet layout of the root home page.
class RootHomeTabletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomeTabletPageState();
}

class _RootHomeTabletPageState extends State<RootHomeTabletPage> {
  int _currentIndex = 0;

  final List<Function> _tabPages = [
    () => LandingHomePage(),
    () => DocumentHomePage(title: "Fleet"),
    () => PlaceholderWidget(
          "Fleet Page Under Construction",
          tab: SelectedTab.fleet,
        ),
    () => PlaceholderWidget(
          "Account Page Under Construction",
          tab: SelectedTab.account,
        )
  ];

  final List<Function> _tabHeaders = [
    (BuildContext context) => buildLandingHomePageTabletHeader(context),
    (BuildContext context) => AppBar(title: Text("fleet")),
    (BuildContext context) => AppBar(title: Text("doc")),
    (BuildContext context) => AppBar(title: Text("account")),
  ];

  @override
  Widget build(BuildContext context) => BlocProvider<SelectedSiteBloc>(
      create: (_) => getIt<SelectedSiteBloc>()..add(SelectedSiteInit(context)),
      child: Scaffold(
          appBar: _tabHeaders[_currentIndex](context),
          body: _tabPages[_currentIndex](),
          bottomNavigationBar: BottomNavigation(action: _setCurrentIndex)));

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
  Widget build(BuildContext context) => Center(
          child: ElevatedButton(
        child: Text('Show Calendar Dialog'),
        onPressed: _showMaterialDialog,
      ));

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
        child: CalendarSheet(
            confirmSelectedDateAction: action,
            initialSelectedDate: initialSelectedDate),
      );
}
