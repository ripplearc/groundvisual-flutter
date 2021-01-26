import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/BarRodMagnifier.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeDailyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => genChartSectionWithTitle(
      context,
      AspectRatio(
        aspectRatio: 1.8,
        child: Stack(
          children: [_buildBarChartCard(context), _buildThumbnailImage()],
        ),
      ),
      true);

  BlocBuilder _buildThumbnailImage() =>
      BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
        buildWhen: (previous, current) => current is SiteSnapShotThumbnail,
        builder: (context, state) => Positioned(
          top: 0.0,
          right: 0.0,
          child: _buildThumbnailImageUponTouch(state),
        ),
      );

  Widget _buildThumbnailImageUponTouch(DailyWorkingTimeState state) {
    if (state is SiteSnapShotThumbnail) {
      return Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 6.0),
          child: Image.asset(
            state.assetName,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
          ));
    } else {
      return Container();
    }
  }

  Positioned _buildBarChartCard(BuildContext context) => Positioned.fill(
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: Theme.of(context).colorScheme.background,
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
              child:
                  BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
                      buildWhen: (previous, current) =>
                          current is DailyWorkingTimeDataLoaded,
                      builder: (context, state) {
                        if (state is DailyWorkingTimeDataLoaded) {
                          return _BarChart(barChartDataAtDate: state);
                        } else {
                          return Container();
                        }
                      }))));
}

class _BarChart extends StatefulWidget {
  final DailyWorkingTimeDataLoaded barChartDataAtDate;

  const _BarChart({Key key, this.barChartDataAtDate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarChartState(barChartDataAtDate);
}

class _BarChartState extends State<_BarChart> {
  final DailyWorkingTimeDataLoaded barChartDataAtDate;

  _BarChartState(this.barChartDataAtDate);

  int _touchedBarGroupIndex = -1;
  int _touchedRodDataIndex = -1;

  @override
  Widget build(BuildContext context) => BarChart(
        BarChartData(
            alignment: BarChartAlignment.center,
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.background,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        barChartDataAtDate.chartData.tooltips[groupIndex]
                            [rodIndex]),
                touchCallback: (response) => _uponSelectingBarRod(response)),
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
            barGroups:
                BarRodMagnifier(context, _touchedBarGroupIndex, _touchedRodDataIndex)
                    .highlightSelectedGroupIfAny(barChartDataAtDate.chartData.bars)),
      );

  void _uponSelectingBarRod(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      _highlightSelectedBar(barTouchResponse);
      _signalDateTimeSelection(barTouchResponse);
    }
  }

  void _signalDateTimeSelection(BarTouchResponse barTouchResponse) =>
      BlocProvider.of<DailyWorkingTimeChartBloc>(context).add(
          SelectDailyChartBarRod(
              barTouchResponse.spot.touchedBarGroupIndex,
              barTouchResponse.spot.touchedRodDataIndex,
              barChartDataAtDate.siteName,
              barChartDataAtDate.date,
              context));

  void _highlightSelectedBar(BarTouchResponse barTouchResponse) {
    setState(() {
      _touchedBarGroupIndex = barTouchResponse.spot.touchedBarGroupIndex;
      _touchedRodDataIndex = barTouchResponse.spot.touchedRodDataIndex;
    });
  }
}
