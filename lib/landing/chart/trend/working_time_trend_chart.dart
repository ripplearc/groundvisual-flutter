import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_magnifier.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_measurement.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_palette.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_transformer.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:tuple/tuple.dart';

/// Widget displays the working and idling time during a certain period.
class WorkingTimeTrendChart extends StatelessWidget {
  final TrendWorkingTimeDataLoaded trendChartData;
  final double aspectRatio;
  final bool showTitle;

  WorkingTimeTrendChart(
      {@required this.trendChartData,
      this.aspectRatio = 1.8,
      this.showTitle = true});

  @override
  Widget build(BuildContext context) => showTitle
      ? chartSectionWithTitleBuilder(
          context: context,
          builder: _buildCardContent(context),
          compacted: false)
      : _buildCardContent(context);

  AspectRatio _buildCardContent(BuildContext context) =>
      AspectRatio(aspectRatio: aspectRatio, child: _buildBarChartCard(context));

  Card _buildBarChartCard(BuildContext context) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
            child: getIt<TrendBarRodMeasurement>(
                    param1: context, param2: trendChartData.period)
                .let((ruler) => _BarChart(
                    ruler: ruler,
                    trendChartData: trendChartData
                        .transformBarChart(BarRodPalette(context).colorBarRod)
                        .transformBarChart(ruler.setBarWidth)
                        .transformBarGroup(ruler.setBarSpace)))),
      );
}

class _BarChart extends StatefulWidget {
  final TrendWorkingTimeDataLoaded trendChartData;
  final TrendBarRodMeasurement ruler;

  const _BarChart(
      {Key key, @required this.trendChartData, @required this.ruler})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarChartState(trendChartData);
}

class _BarChartState extends State<_BarChart> {
  final TrendWorkingTimeDataLoaded trendChartData;

  _BarChartState(this.trendChartData);

  int _touchedBarGroupIndex = -1;
  int _touchedRodDataIndex = -1;

  @override
  Widget build(BuildContext context) => BarChart(BarChartData(
        alignment: BarChartAlignment.center,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.background,
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  _buildBarTooltipItem(groupIndex, rodIndex, context)),
          touchCallback: (barTouchResponse) => _uponSelectingBarRod(
            barTouchResponse,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
            margin: 2,
            getTitles: (double index) =>
                trendChartData.chartData.bottomTitles[index.toInt()],
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: trendChartData.chartData.leftTitleInterval,
            getTextStyles: (value) => Theme.of(context).textTheme.caption,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        groupsSpace: widget.ruler.groupSpace,
        barGroups: magnifyValue(trendChartData.period).let((magnifying) =>
            trendChartData.chartData.bars.mapSelectedBarRod(
                _touchedBarGroupIndex,
                _touchedRodDataIndex,
                BarRodMagnifier(magnifying.item1, magnifying.item1, context)
                    .highlightBarRod)),
      ));

  BarTooltipItem _buildBarTooltipItem(
          int groupIndex, int rodIndex, BuildContext context) =>
      BarTooltipItem(
          trendChartData.chartData.tooltips[groupIndex][rodIndex],
          Theme.of(context)
              .textTheme
              .caption
              .apply(color: Theme.of(context).colorScheme.onBackground));

  Tuple2<double, double> magnifyValue(TrendPeriod period) {
    switch (period) {
      case TrendPeriod.oneWeek:
        return Tuple2(1.1, 1.1);
      case TrendPeriod.twoWeeks:
        return Tuple2(1.2, 1.1);
      case TrendPeriod.oneMonth:
        return Tuple2(1.5, 1.1);
      case TrendPeriod.twoMonths:
        return Tuple2(1.7, 1.1);
      default:
        return Tuple2(1, 1);
    }
  }

  void _uponSelectingBarRod(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      _highlightSelectedBar(barTouchResponse);
      _signalDateTimeSelection(barTouchResponse);
    }
  }

  void _signalDateTimeSelection(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      BlocProvider.of<TrendWorkingTimeChartBloc>(context).add(
          SelectTrendChartBarRod(
              barTouchResponse.spot.touchedBarGroupIndex,
              barTouchResponse.spot.touchedRodDataIndex,
              trendChartData.siteName,
              trendChartData.dateRange,
              trendChartData.period,
              context));
    }
  }

  void _highlightSelectedBar(BarTouchResponse barTouchResponse) {
    setState(() {
      _touchedBarGroupIndex = barTouchResponse.spot.touchedBarGroupIndex;
      _touchedRodDataIndex = barTouchResponse.spot.touchedRodDataIndex;
    });
  }
}
