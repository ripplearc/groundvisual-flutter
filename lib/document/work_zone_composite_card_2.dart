import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_large_card.dart';

class WorkZoneCompositeCardTwo extends StatelessWidget {
  final double mapAspectRatio;
  final double embeddedContentAspectRatio;
  final double embeddedContentSidePadding;
  final double embeddedContentBottomPadding;
  final Widget embeddedContent;

  const WorkZoneCompositeCardTwo({
    Key key,
    this.mapAspectRatio = 0.75,
    this.embeddedContentAspectRatio = 1.3,
    this.embeddedContentSidePadding = 10,
    this.embeddedContentBottomPadding = 10,
    @required this.embeddedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: mapAspectRatio,
      child: Stack(
        children: [
          _buildMapCard(_calcMapBottomPadding(context)),
          _buildEmbeddedContent(),
        ],
      ));

  double _calcMapBottomPadding(BuildContext context) =>
      (MediaQuery.of(context).size.width - 2 * embeddedContentSidePadding) /
          embeddedContentAspectRatio +
      embeddedContentBottomPadding;

  Widget _buildMapCard(double bottomPadding) => Positioned.fill(
      child: WorkZoneMapLargeCard(bottomPadding: bottomPadding));

  Widget _buildEmbeddedContent() => Positioned.fill(
      bottom: embeddedContentBottomPadding,
      left: embeddedContentSidePadding,
      right: embeddedContentSidePadding,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AspectRatio(
            aspectRatio: embeddedContentAspectRatio, child: embeddedContent),
      ));
}
