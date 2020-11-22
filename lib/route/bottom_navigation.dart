import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigation extends StatefulWidget {
  final Function() action;

  const BottomNavigation({Key key, this.action}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BottomNavigationState(action);
}

class _BottomNavigationState extends State<BottomNavigation> {
  var _selectedTab = SelectedTab.site;

  final Function() action;

  _BottomNavigationState(this.action);

  void _handleIndexChanged(int i) {
    action();
    setState(() {
      _selectedTab = SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) => SalomonBottomBar(
      currentIndex: SelectedTab.values.indexOf(_selectedTab),
      onTap: _handleIndexChanged,
      items: SelectedTab.values.map((element) {
        return SalomonBottomBarItem(
          icon: element._icon(),
          title: element._text(),
          selectedColor: Theme.of(context).colorScheme.primary,
          unselectedColor: Theme.of(context).colorScheme.onBackground,
        );
      }).toList());
}

enum SelectedTab { site, fleet, doc, account }

extension _Value on SelectedTab {
  Icon _icon() {
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

  Text _text() {
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
