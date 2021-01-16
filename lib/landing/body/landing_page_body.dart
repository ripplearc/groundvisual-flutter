import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_slide_show.dart';
import 'package:groundvisual_flutter/landing/machine/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map.dart';

class LandingHomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDate) {
          return SliverList(delegate: _dateSliverChildBuilder);
        } else if (state is SelectedSiteAtTrend) {
          return SliverList(delegate: _trendSliverChildBuilder);
        } else {
          return Container();
        }
      });

  SliverChildBuilderDelegate get _dateSliverChildBuilder =>
      SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          switch (index) {
            case 0:
              return WorkZoneMap();
            case 1:
              return WorkingTimeChart();
            case 2:
              return DailyDigestSlideShow();
            case 3:
              return MachineWorkingTimeList();
            default:
              return Container();
          }
        },
        childCount: 4,
      );

  SliverChildBuilderDelegate get _trendSliverChildBuilder =>
      SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          switch (index) {
            case 0:
              return WorkZoneMap();
            case 1:
              return WorkingTimeChart();
            case 2:
              return MachineWorkingTimeList();
            default:
              return Container();
          }
        },
        childCount: 3,
      );

  void _tapDetail(BuildContext context, FluroRouter router, String key) {
    String message = "";
    String hexCode = "#FFFFFF";
    TransitionType transitionType = TransitionType.native;
    hexCode = "#F76F00";
    message =
        "This screen should have appeared using the default flutter animation for the current OS";
    transitionType = TransitionType.inFromRight;

    String route = "/site/detail?message=$message&color_hex=$hexCode";

    router
        .navigateTo(context, route, transition: transitionType)
        .then((result) {
      if (key == "pop-result") {
        router.navigateTo(context, "/demo/func?message=$result");
      }
    });
  }
}
