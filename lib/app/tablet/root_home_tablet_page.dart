import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/fleet/fleet_page_body.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/tablet/landing_page_tablet_header.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

/// Tablet layout of the root home page.
class RootHomeTabletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomeTabletPageState();
}

class _RootHomeTabletPageState extends State<RootHomeTabletPage>
    with PersistentBottomNavigation {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) => BlocProvider<SelectedSiteBloc>(
      create: (_) => getIt<SelectedSiteBloc>()..add(SelectedSiteInit(context)),
      child: Scaffold(
          appBar: buildLandingHomePageTabletHeader(context),
          body: buildTabBar(
              controller: _controller, screens: _screens, context: context)));

  List<Widget> get _screens => [
        LandingHomePage(),
        FleetHomePage(title: "Fleet"),
        PlaceholderWidget(
          pageTitle: "Document Page Under Construction",
          tab: SelectedTab.fleet,
        ),
        PlaceholderWidget(
          pageTitle: "Account Page Under Construction",
          tab: SelectedTab.account,
        )
      ];
}
