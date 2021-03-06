import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/date_or_trend_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/component/site/site_dropdown_list.dart';
import 'package:groundvisual_flutter/landing/appbar/component/toggle/day_trend_toggle.dart';

AppBar buildLandingHomePageTabletHeader(SelectedSiteBloc selectedSiteBloc) =>
    AppBar(
      leadingWidth: 200,
      leading: BlocProvider<SelectedSiteBloc>(
          create: (_) => selectedSiteBloc,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: SiteDropDownList(),
          )),
      actions: [
        BlocProvider<SelectedSiteBloc>(
            create: (_) => selectedSiteBloc,
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Center(
                        child: DateTrendToggle(
                      widthPercent: 10,
                      height: 30,
                    )))
              ],
            ))
      ],
      elevation: 1,
      backgroundColor: Colors.white,
    );
// Column(
// mainAxisAlignment: MainAxisAlignment.end,
// mainAxisSize: MainAxisSize.max,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Expanded(
// child: Container(
// width: double.infinity,
// ),
// ),
// Container(
// height: 40.0,
// width: 130.0,
// child: SiteDropDownList(),
// ),
// Padding(padding: EdgeInsets.all(2.0)),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// mainAxisSize: MainAxisSize.max,
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Padding(padding: EdgeInsets.all(4.0)),
// ],
// )
