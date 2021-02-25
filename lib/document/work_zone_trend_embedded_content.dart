import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';

class WorkZoneTrendEmbeddedContent extends StatelessWidget {
  final double chartCardAspectRatio;

  const WorkZoneTrendEmbeddedContent({
    Key key,
    this.chartCardAspectRatio = 1.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildChartCard();

  Widget _buildChartCard() => Positioned.fill(
        child: WorkingTimeEmbeddedChart(aspectRatio: chartCardAspectRatio),
      );
}
