import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/body/phone/composite/work_zone_daily_embedded_content.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';

class LandingHomePageTabletBody extends StatelessWidget {
  get bottomPadding => null;

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
                  child: WorkZoneDailyEmbeddedContent(),
                ))),
      ]);
}
