import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';

/// Widget displays the working and idling time during a certain period.
class WorkingTimeTrendChart extends StatelessWidget {
  final SelectedSiteAtWindow selectedSiteAtWindow;

  WorkingTimeTrendChart(this.selectedSiteAtWindow);

  @override
  Widget build(BuildContext context) =>
      AspectRatio(aspectRatio: 1.8, child: _buildBarChartCard(context));

  Card _buildBarChartCard(BuildContext context) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
          child: _BarChart(selectedSiteAtWindow: selectedSiteAtWindow),
        ),
      );
}

class _BarChart extends StatelessWidget {
  final SelectedSiteAtWindow selectedSiteAtWindow;

  const _BarChart({Key key, this.selectedSiteAtWindow}) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildBarChart(context);

  BarChart _buildBarChart(BuildContext context) => BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Theme.of(context).colorScheme.background,
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    selectedSiteAtWindow.chartData.tooltips[groupIndex]
                        [rodIndex]),
            touchCallback: (barTouchResponse) =>
                _triggerBarRodSelectionEventUponTouch(
              barTouchResponse,
              context,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
              margin: 2,
              getTitles: (double index) =>
                  selectedSiteAtWindow.chartData.bottomTitles[index.toInt()],
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: selectedSiteAtWindow.chartData.leftTitleInterval,
              getTextStyles: (value) => Theme.of(context).textTheme.caption,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: selectedSiteAtWindow.chartData.space,
          barGroups: selectedSiteAtWindow.chartData.bars,
        ),
      );

  void _triggerBarRodSelectionEventUponTouch(
      BarTouchResponse barTouchResponse, BuildContext context) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      BlocProvider.of<WorkingTimeChartTouchBloc>(context).add(
          TrendChartBarRodSelection(
              barTouchResponse.spot.touchedBarGroupIndex,
              barTouchResponse.spot.touchedRodDataIndex,
              selectedSiteAtWindow.siteName,
              selectedSiteAtWindow.dateRange,
              selectedSiteAtWindow.period,
              context));
    }
  }
}
