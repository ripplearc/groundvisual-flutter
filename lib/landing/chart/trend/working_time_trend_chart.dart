import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/chart/date/bloc/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeTrendChart extends StatelessWidget {
  final WorkingTimeChartData data;

  WorkingTimeTrendChart(this.data);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) =>
            getIt<WorkingTimeChartTouchBloc>()..add(NoBarRodSelection()),
        child:
            AspectRatio(aspectRatio: 1.8, child: _buildBarChartCard(context)),
      );

  Card _buildBarChartCard(BuildContext context) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
          child: _BarChart(data: data),
          // child: Stack(children: [_buildBarChart(context)]),
        ),
      );
}

class _BarChart extends StatelessWidget {
  final WorkingTimeChartData data;

  const _BarChart({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildBarChart(context);

  BarChart _buildBarChart(BuildContext context) => BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Theme.of(context).colorScheme.background,
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    data.tooltips[groupIndex][rodIndex]),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
              margin: 2,
              getTitles: (double index) => data.bottomTitles[index.toInt()],
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: data.leftTitleInterval,
              getTextStyles: (value) => Theme.of(context).textTheme.caption,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: 16,
          barGroups: data.bars,
        ),
      );
}
