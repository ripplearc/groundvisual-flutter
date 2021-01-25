import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_shimmer.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_shimmer.dart';

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
                          current is WorkingTimeBarChartDataLoaded,
                      builder: (context, state) {
                        if (state is WorkingTimeBarChartDataLoaded) {
                          return _BarChart(barChartDataAtDate: state);
                        } else {
                          return Container();
                        }
                      }))));
}

class _BarChart extends StatefulWidget {
  final WorkingTimeBarChartDataLoaded barChartDataAtDate;

  const _BarChart({Key key, this.barChartDataAtDate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarChartState(barChartDataAtDate);
}

class _BarChartState extends State<_BarChart> {
  final WorkingTimeBarChartDataLoaded barChartDataAtDate;

  final _horizontalMagnifier = 3;
  final _verticalMagnifier = 1.5;

  int _touchedBarGroupIndex = -1;
  int _touchedRodDataIndex = -1;

  _BarChartState(this.barChartDataAtDate);

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
            barGroups: _highlightSelectedGroupIfAny()),
      );

  List<BarChartGroupData> _highlightSelectedGroupIfAny() =>
      barChartDataAtDate.chartData.bars.asMap().entries.map((entry) {
        if (entry.key == _touchedBarGroupIndex) {
          BarChartGroupData groupData = entry.value;
          return BarChartGroupData(
              x: groupData.x,
              barsSpace: groupData.barsSpace,
              barRods: _highlightSelectedBarRodIfAny(groupData));
        } else {
          return entry.value;
        }
      }).toList();

  List<BarChartRodData> _highlightSelectedBarRodIfAny(
          BarChartGroupData groupData) =>
      groupData.barRods.asMap().entries.map((entry) {
        if (entry.key == _touchedRodDataIndex) {
          BarChartRodData rodData = entry.value;
          return BarChartRodData(
              y: rodData.y * _verticalMagnifier,
              width: rodData.width * _horizontalMagnifier,
              borderRadius: rodData.borderRadius,
              rodStackItems: _recolorStackItem(rodData));
        } else {
          return entry.value;
        }
      }).toList();

  List<BarChartRodStackItem> _recolorStackItem(BarChartRodData rodData) =>
      rodData.rodStackItems.asMap().entries.map((entry) {
        BarChartRodStackItem item = entry.value;
        if (entry.key == 0) {
          return BarChartRodStackItem(
              item.fromY * _verticalMagnifier,
              item.toY * _verticalMagnifier,
              Theme.of(context).colorScheme.primaryVariant);
        } else if (entry.key == 1) {
          return BarChartRodStackItem(item.fromY * _verticalMagnifier,
              item.toY * _verticalMagnifier, item.color);
        } else {
          return item;
        }
      }).toList();

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
          DailyChartBarRodSelection(
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
