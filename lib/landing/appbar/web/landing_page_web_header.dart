import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/date_or_trend_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/component/site/site_dropdown_list.dart';
import 'package:groundvisual_flutter/landing/appbar/component/toggle/day_trend_toggle.dart';

/// Build the landing home page AppBar for web with site and date selections.
AppBar buildLandingHomePageWebHeader(BuildContext context) => AppBar(
  leadingWidth: 200,
  flexibleSpace: Stack(children: [
    Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(7),
          child: Image(
              image: AssetImage('assets/icon/logo.png'),
              color: Theme.of(context).colorScheme.primary),
        )),
    Center(
        child: Container(
          width: 200,
          child: SiteDropDownList(),
        ))
  ]),
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
