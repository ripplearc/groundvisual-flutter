import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/viewmodel/working_time_daily_chart_viewmodel.dart';

class WorkingTimeDailyChart extends StatelessWidget {
  final WorkingTimeDailyChartData data;

  WorkingTimeDailyChart(this.data);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.8,
        child: _buildBarChartCard(context),
      );

  Card _buildBarChartCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
        child: _buildBarChart(context),
        // child: Stack(children: [_buildBarChart(context)]),
      ),
    );
  }

  BarChart _buildBarChart(BuildContext context) {
    return BarChart(
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
            interval: 15,
            getTextStyles: (value) => Theme.of(context).textTheme.caption,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        groupsSpace: 1.8,
        barGroups: data.bars,
      ),
    );
  }
}
