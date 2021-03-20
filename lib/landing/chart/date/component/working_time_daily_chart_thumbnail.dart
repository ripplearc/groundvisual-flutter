import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'package:shimmer/shimmer.dart';

/// Thumbnail image shown based on timestamp of the selected bar rod.
class WorkingTimeDailyChartThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
          buildWhen: (previous, current) =>
              current is SiteSnapShotThumbnailLoaded ||
              current is SiteSnapShotLoading ||
              current is SiteSnapShotHiding,
          builder: (context, state) =>
              _genThumbnailImageUponTouch(state, context));

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
}
