import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/mode/portrait_mode_mixin.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/fleet/fleet_page_body.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/landing_home_page.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

/// Mobile layout of the root home page. The mobile layout should maintain the portrait mode.
class RootHomeMobilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootHomeMobilePageState();
}

class _RootHomeMobilePageState extends State<RootHomeMobilePage>
    with PortraitStatefulModeMixin<RootHomeMobilePage>, PersistentBottomNavigation {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<SelectedSiteBloc>(
        create: (_) =>
            getIt<SelectedSiteBloc>()..add(SelectedSiteInit(context)),
        child: Scaffold(
            body: buildTabBar(
                controller: _controller, screens: _screens, context: context)));
  }

  List<Widget> get _screens => [
        LandingHomePage(),
        FleetHomePage(title: "Fleet"),
        PlaceholderWidget(
          pageTitle: "Document Page Under Construction",
          tab: SelectedTab.doc,
        ),
        PlaceholderWidget(
          pageTitle: "Account Page Under Construction",
          tab: SelectedTab.account,
        )
      ];
}
