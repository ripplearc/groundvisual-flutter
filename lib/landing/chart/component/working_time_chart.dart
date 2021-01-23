import 'package:dart_date/dart_date.dart';
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
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(builder: (context, state) {
        if (state is SelectedSiteAtDate) {
          BlocProvider.of<WorkingTimeChartTouchBloc>(context)
              .add(NoBarRodSelection(state.siteName, state.date, context));
          return state.chartData == null
              ? WorkingTimeDailyChartShimmer()
              : WorkingTimeDailyChart(state);
        } else if (state is SelectedSiteAtTrend) {
          BlocProvider.of<WorkingTimeChartTouchBloc>(context)
              .add(NoBarRodSelection(state.siteName, Date.startOfToday, context));
          return state.chartData == null
              ? WorkingTimeTrendChartShimmer(period: state.period)
              : WorkingTimeTrendChart(state);
        } else {
          return Container();
        }
      });

}
