import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';

/// Widget that embeds the trend chart inside the map chart.
class WorkZoneTrendEmbeddedContent extends StatelessWidget {
  final double chartCardAspectRatio;

  const WorkZoneTrendEmbeddedContent({
    Key key,
    this.chartCardAspectRatio = 1.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      WorkingTimeEmbeddedChart(aspectRatio: chartCardAspectRatio);
}
