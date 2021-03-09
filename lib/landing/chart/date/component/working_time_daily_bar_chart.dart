import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_magnifier.dart';
import 'package:tuple/tuple.dart';

/// BarChart that updates itself with the data stream.
class WorkingTimeDailyBarChart extends StatelessWidget {
  final DailyWorkingTimeDataLoaded barChartDataAtDate;

  const WorkingTimeDailyBarChart({Key key, @required this.barChartDataAtDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<Tuple2<int, int>>(
      stream: barChartDataAtDate.highlightRodBarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _genBarChart(context, snapshot.data);
        } else {
          return _genBarChart(context, Tuple2(-1, -1));
        }
      });

  BarChart _genBarChart(BuildContext context, Tuple2<int, int> highlight) =>
      BarChart(
        BarChartData(
            alignment: BarChartAlignment.center,
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.background,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        _buildBarTooltipItem(groupIndex, rodIndex, context)),
                touchCallback: (response) =>
                    _uponSelectingBarRod(response, context)),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => Theme.of(context).textTheme.caption,
                margin: 2,
                getTitles: (double index) =>
                    barChartDataAtDate.chartData.bottomTitles[index.toInt()],
              ),
              leftTitles: SideTitles(
                showTitles: true,
                interval: barChartDataAtDate.chartData.leftTitleInterval,
                getTextStyles: (value) => Theme.of(context).textTheme.caption,
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            groupsSpace: 1.8,
            barGroups: BarRodMagnifier(
                    context, highlight.item1, highlight.item2,
                    horizontalMagnifier: 3, verticalMagnifier: 1.2)
                .highlightSelectedGroupIfAny(
                    barChartDataAtDate.chartData.bars)),
      );

  BarTooltipItem _buildBarTooltipItem(
          int groupIndex, int rodIndex, BuildContext context) =>
      BarTooltipItem(
          barChartDataAtDate.chartData.tooltips[groupIndex][rodIndex],
          Theme.of(context)
              .textTheme
              .caption
              .apply(color: Theme.of(context).colorScheme.onBackground));

  void _uponSelectingBarRod(
      BarTouchResponse barTouchResponse, BuildContext context) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      _signalDateTimeSelection(barTouchResponse, context);
    }
  }

  void _signalDateTimeSelection(
          BarTouchResponse barTouchResponse, BuildContext context) =>
      BlocProvider.of<DailyWorkingTimeChartBloc>(context).add(
          SelectDailyChartBarRod(
              barTouchResponse.spot.touchedBarGroupIndex,
              barTouchResponse.spot.touchedRodDataIndex,
              barChartDataAtDate.siteName,
              barChartDataAtDate.date));
}
