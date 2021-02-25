import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer displayed when fetching data for the WorkingTimeDailyChart.
class WorkingTimeDailyChartShimmer extends StatelessWidget {
  final double aspectRatio;
  final Widget embeddedBackground;
  final bool showTitle;

  const WorkingTimeDailyChartShimmer(
      {Key key,
      this.aspectRatio,
      this.embeddedBackground,
      this.showTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => showTitle
      ? chartSectionWithTitleBuilder(
          context: context, builder: _buildShimmer(context), compacted: true)
      : _buildShimmer(context);

  AspectRatio _buildShimmer(BuildContext context) => AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        color: embeddedBackground != null
            ? Colors.transparent
            : Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            Positioned.fill(child: embeddedBackground ?? Container()),
            Positioned.fill(child: _buildShimmerContent(context)),
          ],
        ),
      ));

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
                96,
                (index) => Container(
                      width: 1.5,
                      height: pow(min(index, 96 - index), 1.3) *
                          random.nextDouble(),
                      color: Theme.of(context).colorScheme.background,
                    )).toList(growable: true)),
      ),
    );
  }
}
