import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WorkingTimeDailyChartShimmer extends StatefulWidget {
  @override
  _WorkingTimeDailyChartShimmerState createState() =>
      _WorkingTimeDailyChartShimmerState();
}

/// A shimmer displays when the daily chart being generated.
class _WorkingTimeDailyChartShimmerState
    extends State<WorkingTimeDailyChartShimmer> {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.8,
        child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: Theme.of(context).colorScheme.background,
            child: _buildShimmerContent(context)));
  }

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
