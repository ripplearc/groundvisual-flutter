import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WorkingTimeTrendChartShimmer extends StatelessWidget {
  final int numberOfDays;

  const WorkingTimeTrendChartShimmer({Key key, this.numberOfDays}) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 1.8,
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: Theme.of(context).colorScheme.background,
          child: _buildShimmerContent(context)));

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
                        numberOfDays,
                        (index) => Container(
                              width: 24,
                              height: 96 * random.nextDouble(),
                              color: Theme.of(context).colorScheme.background,
                            )).toList(growable: true))),
          ),
        ],
      ),
    );
  }
}
