import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

/// Display bottom navigation tabs. The action notifies about the selected tab.
mixin BottomNavigation {
  PersistentTabView buildTabBar(
      {required PersistentTabController controller,
      required List<Widget> screens,
      required BuildContext context}) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      hideNavigationBar: false,
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      items: _buildNavBarItems(Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.onSurface),
      navBarStyle: NavBarStyle.style1,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  List<PersistentBottomNavBarItem> _buildNavBarItems(
          Color activeColor, Color inactiveColor) =>
      SelectedTab.values
          .map((tab) => PersistentBottomNavBarItem(
              icon: Icon(tab.icon),
              title: tab.name,
              activeColorPrimary: activeColor,
              inactiveColorPrimary: inactiveColor))
          .toList();
}

enum SelectedTab { site, fleet, doc, account }

extension Value on SelectedTab {
  IconData get icon {
    switch (this) {
      case SelectedTab.site:
        return Icons.foundation;
      case SelectedTab.fleet:
        return Icons.swap_horiz;
      case SelectedTab.doc:
        return Icons.toc;
      case SelectedTab.account:
        return Icons.person_outline;
    }
  }

  String get name {
    switch (this) {
      case SelectedTab.site:
        return "Site";
      case SelectedTab.fleet:
        return "Fleet";
      case SelectedTab.doc:
        return "Doc";
      case SelectedTab.account:
        return "Account";
    }
  }
}
