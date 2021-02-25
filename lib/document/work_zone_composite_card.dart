import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_show.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_large_card.dart';

class WorkZoneCompositeCard extends StatelessWidget {
  final double mapAspectRatio;
  final double digestCardAspectRatio;
  final double digestCardBottomPadding;
  final double cardSidePadding;
  final double chartBottomPadding;
  final double chartCardAspectRatio;

  const WorkZoneCompositeCard(
      {Key key,
      this.mapAspectRatio = 0.75,
      this.digestCardAspectRatio = 336 / 190,
      this.digestCardBottomPadding = 80,
      this.cardSidePadding = 10,
      this.chartBottomPadding = 10,
      this.chartCardAspectRatio = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: mapAspectRatio,
      child: Stack(
        children: [
          _buildMapCard(_calcMapBottomPadding(context)),
          _buildDigestCard(),
          _buildChartCard()
        ],
      ));

  double _calcMapBottomPadding(BuildContext context) =>
      (MediaQuery.of(context).size.width - 2 * cardSidePadding) /
          digestCardAspectRatio +
      digestCardBottomPadding;

  Widget _buildMapCard(double bottomPadding) => Positioned.fill(
      child: WorkZoneMapLargeCard(bottomPadding: bottomPadding));

  Widget _buildDigestCard() => Positioned.fill(
      bottom: digestCardBottomPadding,
      left: cardSidePadding,
      right: cardSidePadding,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DailyDigestSlideShow(aspectRatio: digestCardAspectRatio),
      ));

  Widget _buildChartCard() => Positioned.fill(
      bottom: chartBottomPadding,
      left: cardSidePadding,
      right: cardSidePadding,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: WorkingTimeEmbeddedChart(aspectRatio: chartCardAspectRatio),
      ));
}
