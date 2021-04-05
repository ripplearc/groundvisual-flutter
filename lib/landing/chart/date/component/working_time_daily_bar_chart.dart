import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_magnifier.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_measurement.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_transformer.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:tuple/tuple.dart';

/// BarChart that updates itself with the data stream.
class WorkingTimeDailyBarChart extends StatelessWidget {
  final DailyWorkingTimeDataLoaded barChartDataAtDate;
  final DailyBarRodMeasurement ruler;

  const WorkingTimeDailyBarChart(
      {Key? key, required this.barChartDataAtDate, required this.ruler})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<Tuple2<int, int>>(
      stream: barChartDataAtDate.highlightRodBarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _genBarChart(
              context,
              snapshot.data ??
                  Tuple2(SelectDailyChartBarRod.UnSelectedGroupId,
                      SelectDailyChartBarRod.UnSelectedRodId));
        } else {
          return _genBarChart(
              context,
              Tuple2(SelectDailyChartBarRod.UnSelectedGroupId,
                  SelectDailyChartBarRod.UnSelectedRodId));
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
            bottomTitles: Theme.of(context)
                .textTheme
                .caption
                ?.let((textStyle) => SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => textStyle,
                      margin: 2,
                      getTitles: (double index) => barChartDataAtDate
                          .chartData.bottomTitles[index.toInt()],
                    )),
            leftTitles: Theme.of(context)
                .textTheme
                .caption
                ?.let((textStyle) => SideTitles(
                      showTitles: true,
                      interval: barChartDataAtDate.chartData.leftTitleInterval,
                      getTextStyles: (value) => textStyle,
                    )),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: ruler.groupSpace,
          barGroups: barChartDataAtDate.chartData.bars.mapSelectedBarRod(
              highlight.item1,
              highlight.item2,
              BarRodMagnifier(3, 1.2, context).highlightBarRod),
        ),
      );

  BarTooltipItem? _buildBarTooltipItem(
          int groupIndex, int rodIndex, BuildContext context) =>
      Theme.of(context)
          .textTheme
          .caption
          ?.apply(color: Theme.of(context).colorScheme.onBackground)
          .let((textStyle) => BarTooltipItem(
              barChartDataAtDate.chartData.tooltips[groupIndex][rodIndex],
              textStyle));

  void _uponSelectingBarRod(
      BarTouchResponse touchResponse, BuildContext context) {
    if (touchResponse.spot != null &&
        (touchResponse.touchInput is PointerDownEvent ||
            touchResponse.touchInput is PointerMoveEvent ||
            touchResponse.touchInput is PointerHoverEvent)) {
      _signalDateTimeSelection(touchResponse, context);
    }
  }

  void _signalDateTimeSelection(
          BarTouchResponse barTouchResponse, BuildContext context) =>
      BlocProvider.of<DailyWorkingTimeChartBloc>(context).add(
          SelectDailyChartBarRod(
              barTouchResponse.spot?.touchedBarGroupIndex ??
                  SelectDailyChartBarRod.UnSelectedGroupId,
              barTouchResponse.spot?.touchedRodDataIndex ??
                  SelectDailyChartBarRod.UnSelectedGroupId,
              barChartDataAtDate.siteName,
              barChartDataAtDate.date));
}
