import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/date_or_trend_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/component/site/site_dropdown_list.dart';
import 'package:groundvisual_flutter/landing/appbar/component/toggle/day_trend_toggle.dart';

/// Build the landing home page AppBar with site and date selections.
AppBar buildLandingHomePageTabletHeader(BuildContext context) => AppBar(
      leadingWidth: 200,
      leading: Padding(
        padding: EdgeInsets.only(left: 20),
        child: SiteDropDownList(),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 30),
            child: Center(
                child: DateTrendToggle(
              widthPercent: 10,
              height: 30,
            ))),
        Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(height: 20, child: DayOrTrendSelectionButton()))
      ],
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.background,
    );
