import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/chart_section_with_title.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer widget to display before the trend data is available. The number of bars
/// depends on the period.
class WorkingTimeTrendChartShimmer extends StatelessWidget {
  final TrendPeriod period;

  const WorkingTimeTrendChartShimmer({Key key, this.period}) : super(key: key);

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
      false);

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
                        period.toInt(),
                        (index) => Container(
                              width: 24 / (period.toInt() / 7),
                              height: 96 * random.nextDouble(),
                              color: Theme.of(context).colorScheme.background,
                            )).toList(growable: true))),
          ),
        ],
      ),
    );
  }
}
