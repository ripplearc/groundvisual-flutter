import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_show.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_large_card.dart';

class WorkZoneCompositeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 0.75,
      child: Stack(
        children: [_buildMapCard(), _buildDigestCard(), _buildChartCard()],
      ));

  Widget _buildMapCard() => Positioned.fill(child: WorkZoneMapLargeCard());

  Widget _buildDigestCard() => Positioned.fill(
      bottom: 80,
      left: 10,
      right: 10,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DailyDigestSlideShow(),
      ));

  Widget _buildChartCard() => Positioned.fill(
      bottom: 10,
      left: 10,
      right: 10,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: WorkingTimeEmbeddedChart(),
      ));
}
