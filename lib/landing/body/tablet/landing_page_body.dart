import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/body/mobile/composite/digest_working_time_composite_content.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';


/// The tablet version of the Landing Home Page body which devides itself horizontally
/// to map zone and information zone.
class LandingHomePageTabletBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 5,
            child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: WorkZoneMapCard(showTitle: false, embedInCard: false))),
        Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: DigestWorkingZoneCompositeContent(),
                ))),
      ]);
}
