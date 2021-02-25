import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_bar_chart.dart';

/// Embedded widget inside Digest that displays the working and idling time on a certain date.
class WorkingTimeDailyEmbeddedChart extends StatelessWidget {
  final double aspectRatio;
  final Widget embeddedBackground;

  const WorkingTimeDailyEmbeddedChart(
      {Key key, @required this.aspectRatio, this.embeddedBackground})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      AspectRatio(aspectRatio: aspectRatio, child: _buildBarChartCard(context));

  Widget _buildBarChartCard(BuildContext context) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      color: Colors.transparent,
      child: BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
          buildWhen: (previous, current) =>
              current is DailyWorkingTimeDataLoaded,
          builder: (context, state) {
            if (state is DailyWorkingTimeDataLoaded) {
              return Stack(
                children: [
                  Positioned.fill(child: embeddedBackground),
                  Positioned.fill(
                      child:
                          WorkingTimeDailyBarChart(barChartDataAtDate: state))
                ],
              );
            } else {
              return Container();
            }
          }));
}
