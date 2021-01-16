import 'package:dart_date/dart_date.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_shimmer.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_shimmer.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_slide_show.dart';
import 'package:groundvisual_flutter/landing/machine/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map.dart';

class LandingHomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            switch (index) {
              case 0:
                return WorkZoneMap();
              case 1:
                return _displayWorkingTimeChart();
              case 2:
                return DailyDigestSlideShow();
              case 3:
                return MachineWorkingTimeList();
              default:
                return Container();
            }
          },
          childCount: 4,
        ),
      );

  Widget _displayWorkingTimeChart() =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
            if (state is SelectedSiteAtDate) {
              BlocProvider.of<WorkingTimeChartTouchBloc>(context)
                  .add(NoBarRodSelection(state.siteName, state.date, context));
              return state.chartData == null
                  ? WorkingTimeDailyChartShimmer()
                  : WorkingTimeDailyChart(state);
            } else if (state is SelectedSiteAtTrend) {
              BlocProvider.of<WorkingTimeChartTouchBloc>(context).add(
                  NoBarRodSelection(
                      state.siteName, Date.startOfToday, context));
              return state.chartData == null
                  ? WorkingTimeTrendChartShimmer(period: state.period)
                  : WorkingTimeTrendChart(state);
            } else {
              return Container();
            }
          });

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

class ListElement extends StatelessWidget {
  final int index;

  const ListElement({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text("List tile $index");
}
