import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_bar_chart.dart';
import 'package:shimmer/shimmer.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeDailyChart extends StatelessWidget {
  final double aspectRatio;

  const WorkingTimeDailyChart({Key key, this.aspectRatio}) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          children: [_buildBarChartCard(context), _buildThumbnailImage()],
        ),
      );

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
          // color: Theme.of(context).colorScheme.background,
          color: Colors.transparent,
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 20.0, top: 22.0),
              child:
                  BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
                      buildWhen: (previous, current) =>
                          current is DailyWorkingTimeDataLoaded,
                      builder: (context, state) {
                        if (state is DailyWorkingTimeDataLoaded) {
                          return WorkingTimeDailyBarChart(barChartDataAtDate: state);
                        } else {
                          return Container();
                        }
                      }))));
}

