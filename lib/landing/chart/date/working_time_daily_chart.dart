import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/BarRodMagnifier.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';

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
        buildWhen: (previous, current) =>
            current is SiteSnapShotThumbnailLoaded ||
            current is SiteSnapShotLoading ||
            current is SiteSnapShotHiding,
        builder: (context, state) => Positioned(
          top: 0.0,
          right: 0.0,
          child: _genThumbnailImageUponTouch(state, context),
        ),
      );

  Widget _genThumbnailImageUponTouch(
      DailyWorkingTimeState state, BuildContext context) {
    if (state is SiteSnapShotThumbnailLoaded) {
      return _loadImageAsset(state);
    } else if (state is SiteSnapShotLoading) {
      return _shimmingWhileLoadingAsset(context);
    } else {
      return Container();
    }
  }

  Shimmer _shimmingWhileLoadingAsset(BuildContext context) =>
      Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.onSurface,
          child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 6.0),
              child: Container(
                  width: 96,
                  height: 96,
                  color: Theme.of(context).colorScheme.background)));

  Padding _loadImageAsset(SiteSnapShotThumbnailLoaded state) => Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 6.0),
      child: Image.asset(
        state.assetName,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      ));

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
