import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_show.dart';

class WorkZoneDailyEmbeddedContent extends StatelessWidget {
  final double digestCardAspectRatio;
  final double chartCardAspectRatio;

  const WorkZoneDailyEmbeddedContent(
      {Key key,
      this.digestCardAspectRatio = 336 / 190,
      this.chartCardAspectRatio = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [_buildDigestCard(), _buildChartCard()],
      );

  Widget _buildDigestCard() => Positioned.fill(
          child: Align(
        alignment: Alignment.topCenter,
        child: DailyDigestSlideShow(aspectRatio: digestCardAspectRatio),
      ));

  Widget _buildChartCard() => Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: WorkingTimeEmbeddedChart(aspectRatio: chartCardAspectRatio),
      ));
}
