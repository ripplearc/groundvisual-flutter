import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/BarRodMagnifier.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeDailyEmbeddedChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      AspectRatio(aspectRatio: 3, child: _buildBarChartCard(context));

  Widget _buildBackground(BuildContext context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4],
                colors: [Colors.transparent, Theme.of(context).colorScheme.background])),
      );

  Widget _buildBarChartCard(BuildContext context) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      color: Colors.transparent,
      child:
          BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
              buildWhen: (previous, current) =>
                  current is DailyWorkingTimeDataLoaded,
              builder: (context, state) {
                if (state is DailyWorkingTimeDataLoaded) {
                  return Stack(
                    children: [
                      Positioned.fill(child: _buildBackground(context)),
                      Positioned.fill(
                          child: _BarChart(barChartDataAtDate: state))
                    ],
                  );
                } else {
                  return Container();
                }
              }));
}

class _BarChart extends StatelessWidget {
  final DailyWorkingTimeDataLoaded barChartDataAtDate;

  const _BarChart({Key key, this.barChartDataAtDate}) : super(key: key);

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
                        barChartDataAtDate.chartData.tooltips[groupIndex]
                            [rodIndex]),
                touchCallback: (response) =>
                    _uponSelectingBarRod(response, context)),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
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
              barChartDataAtDate.date,
              context));
}
