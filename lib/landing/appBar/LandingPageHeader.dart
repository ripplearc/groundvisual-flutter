import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'SiteDropDownList.dart';
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                  ),
                ),
                Container(
                    height: 20,
                    child: FlatButton.icon(
                      height: 20,
                      icon: Icon(
                        Icons.add_alarm,
                        size: 16,
                      ),
                      label: Text(
                        'Today',
                        style: TextStyle(fontSize: 12),
                      ),
                      textColor: Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.all(0),
                      color: null,
                      onPressed: () {},
                    ))
              ]),
          Padding(padding: EdgeInsets.all(4.0)),
        ],
      ),
    );
  }
}
