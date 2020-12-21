import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';

import '../../bloc/chart_touch/working_time_chart_touch_bloc.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeDailyChart extends StatelessWidget {
  final SelectedSiteAtDate selectedSiteAtDate;

  WorkingTimeDailyChart(this.selectedSiteAtDate);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Stack(
        children: [_buildBarChartCard(context), _buildThumbnailImage()],
      ),
    );
  }

  BlocBuilder _buildThumbnailImage() =>
      BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        buildWhen: (previous, current) => current is SiteSnapShotThumbnail,
        builder: (context, state) => Positioned(
          top: 0.0,
          right: 0.0,
          child: _buildThumbnailImageUponTouch(state),
        ),
      );

  Widget _buildThumbnailImageUponTouch(SiteSnapShotState state) {
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
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
            child: _BarChart(selectedSiteAtDate: selectedSiteAtDate),
            // child: Stack(children: [_buildBarChart(context)]),
          ),
        ),
      );
}

class _BarChart extends StatelessWidget {
  final SelectedSiteAtDate selectedSiteAtDate;

  const _BarChart({Key key, this.selectedSiteAtDate}) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildBarChart(context);

  BarChart _buildBarChart(BuildContext context) => BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.background,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      selectedSiteAtDate.chartData.tooltips[groupIndex]
                          [rodIndex]),
              touchCallback: (barTouchResponse) =>
                  _triggerBarRodSelectionEventUponTouch(
                    barTouchResponse,
                    context,
                  )),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
              margin: 2,
              getTitles: (double index) =>
                  selectedSiteAtDate.chartData.bottomTitles[index.toInt()],
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: selectedSiteAtDate.chartData.leftTitleInterval,
              getTextStyles: (value) => Theme.of(context).textTheme.caption,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: 1.8,
          barGroups: selectedSiteAtDate.chartData.bars,
        ),
      );

  void _triggerBarRodSelectionEventUponTouch(
      BarTouchResponse barTouchResponse, BuildContext context) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      BlocProvider.of<WorkingTimeChartTouchBloc>(context).add(DateChartBarRodSelection(
          barTouchResponse.spot.touchedBarGroupIndex,
          barTouchResponse.spot.touchedRodDataIndex,
          selectedSiteAtDate.siteName,
          selectedSiteAtDate.date,
          context));
    }
  }
}
