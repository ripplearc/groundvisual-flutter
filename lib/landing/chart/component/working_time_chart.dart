import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_shimmer.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_shimmer.dart';

/// Displays the working time of a day or a period.
class WorkingTimeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDate) {
          return BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
              builder: (context, state) {
            return state is WorkingTimeChartLoading
                ? WorkingTimeDailyChartShimmer()
                : WorkingTimeDailyChart();
          });
        } else if (state is SelectedSiteAtTrend) {
          return state.chartData == null
              ? WorkingTimeTrendChartShimmer(period: state.period)
              : WorkingTimeTrendChart(state);
        } else {
          return Container();
        }
      });
}
