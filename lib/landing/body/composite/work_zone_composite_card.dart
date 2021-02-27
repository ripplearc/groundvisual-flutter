import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';

/// The composite widget has map as the background, and host another embedded widget at its bottom.
/// It adds bottom padding based on the height of the embedded widget, so that the center of
/// the map moves accordingly.
class WorkZoneCompositeCard extends StatelessWidget {
  final double mapAspectRatio;
  final double embeddedContentAspectRatio;
  final double embeddedContentSidePadding;
  final double embeddedContentBottomPadding;
  final Widget embeddedContent;

  const WorkZoneCompositeCard({
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
      child:
          WorkZoneMapCard(bottomPadding: bottomPadding, showTitle: false));

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
