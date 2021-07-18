import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/timeline_workzone_map_mixin.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/component/digest_working_time_composite_content.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/widget/daily_timeline.dart';

/// The tablet version of the Landing Home Page body which divides itself horizontally
/// to map zone and information zone.
class LandingHomePageTabletBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingHomePageTabletBodyState();
}

class LandingHomePageTabletBodyState extends State<LandingHomePageTabletBody>
    with WorkZoneMapBuilder {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 5,
            child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: buildMap(context, _controller))),
        Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: ListView(children: [
                  _buildDigestWorkingTime(),
                  DailyTimeline(),
                  MachineWorkingTimeList()
                ]))),
      ]);

  AspectRatio _buildDigestWorkingTime() => AspectRatio(
      aspectRatio: 1.5,
      child: BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          buildWhen: (prev, curr) =>
              curr is SelectedSiteAtDate || curr is SelectedSiteAtTrend,
          builder: (context, state) {
            if (state is SelectedSiteAtDate) {
              return DigestWorkingZoneCompositeContent();
            } else if (state is SelectedSiteAtTrend) {
              return WorkingTimeChart();
            } else {
              return Container();
            }
          }));
}
