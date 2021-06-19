import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer widget to display before the trend data is available. The number of bars
/// depends on the period.
class WorkingTimeTrendChartShimmer extends StatelessWidget {
  final TrendPeriod period;
  final double aspectRatio;
  final bool showTitle;

  const WorkingTimeTrendChartShimmer(
      {Key? key,
      this.period = TrendPeriod.oneWeek,
      this.aspectRatio = 1.8,
      this.showTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => kIsWeb
      ? Container()
      : showTitle
          ? chartSectionWithTitleBuilder(
              context: context,
              builder: _buildShimmer(context),
              compacted: false)
          : _buildShimmer(context);

  AspectRatio _buildShimmer(BuildContext context) => AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: Theme.of(context).colorScheme.background,
          child: _buildShimmerContent(context)));

  Container _buildShimmerContent(BuildContext context) {
    Random random = new Random();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface,
        highlightColor: Theme.of(context).colorScheme.onSurface,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Container>.generate(
                period.days,
                (index) => Container(
                      width: 24 / (period.days / 7),
                      height: 96 * random.nextDouble(),
                      color: Theme.of(context).colorScheme.background,
                    )).toList(growable: true)),
      ),
    );
  }
}
