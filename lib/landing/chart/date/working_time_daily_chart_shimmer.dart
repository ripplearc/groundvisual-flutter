import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer displayed when fetching data for the WorkingTimeDailyChart.
class WorkingTimeDailyChartShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => genChartSectionWithTitle(
      context,
      AspectRatio(
          aspectRatio: 1.8,
          child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Theme.of(context).colorScheme.background,
              child: _buildShimmerContent(context))),
  true);

  Container _buildShimmerContent(BuildContext context) {
    Random random = new Random();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
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
                            )).toList(growable: true))),
          ),
        ],
      ),
    );
  }
}
