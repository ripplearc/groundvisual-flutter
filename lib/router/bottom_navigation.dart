import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

/// Display bottom navigation tabs. The action notifies about the selected tab.
class BottomNavigation extends StatefulWidget {
  final Function(int index) action;

  const BottomNavigation({Key key, this.action}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationState(action);
}

class _BottomNavigationState extends State<BottomNavigation> {
  var _selectedTab = SelectedTab.site;

  final Function(int index) action;

  _BottomNavigationState(this.action);

  void _handleIndexChanged(int i) {
    action(i);
    setState(() {
      _selectedTab = SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) => SalomonBottomBar(
      currentIndex: SelectedTab.values.indexOf(_selectedTab),
      onTap: _handleIndexChanged,
      items: SelectedTab.values
          .map((element) => _buildBarItem(element, context))
          .toList());

  SalomonBottomBarItem _buildBarItem(
          SelectedTab element, BuildContext context) =>
      SalomonBottomBarItem(
        icon: element.icon(),
        title: element.text(),
        selectedColor: Theme.of(context).colorScheme.primary,
        unselectedColor: Theme.of(context).colorScheme.onBackground,
      );
}

enum SelectedTab { site, fleet, doc, account }

extension Value on SelectedTab {
  Icon icon() {
    switch (this) {
      case SelectedTab.site:
        return Icon(Icons.foundation);
      case SelectedTab.fleet:
        return Icon(Icons.swap_horiz);
      case SelectedTab.doc:
        return Icon(Icons.toc);
      case SelectedTab.account:
        return Icon(Icons.person_outline);
    }
    throw ArgumentError('$this is not a valid Trend Period');
  }

  Text text() {
    switch (this) {
      case SelectedTab.site:
        return Text("Site");
      case SelectedTab.fleet:
        return Text("Fleet");
      case SelectedTab.doc:
        return Text("Doc");
      case SelectedTab.account:
        return Text("Account");
    }
    throw ArgumentError('$this is not a valid Trend Period');
  }
}
