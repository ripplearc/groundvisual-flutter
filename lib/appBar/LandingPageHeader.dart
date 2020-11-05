import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/appBar/SiteDropDownList.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'SliverAppBarTitle.dart';

class LandingPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBarTitle(
      shouldStayWhenCollapse: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
            ),
          ),
          Container(
            height: 40.0,
            width: 130.0,
            child: SiteDropDownList(),
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          ToggleSwitch(
            minWidth: 55.0,
            minHeight: 20.0,
            iconSize: 12,
            fontSize: 12,
            cornerRadius: 20.0,
            activeBgColor: Theme.of(context).colorScheme.primary,
            activeFgColor: Colors.white,
            inactiveBgColor: Theme.of(context).colorScheme.onBackground,
            inactiveFgColor: Colors.white,
            labels: ['Day', 'Trend'],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),
          Padding(padding: EdgeInsets.all(4.0)),
        ],
      ),
    );
  }
}
