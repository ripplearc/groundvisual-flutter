import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/component/digest_working_time_composite_content.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/widget/daily_timeline.dart';

/// The tablet version of the Landing Home Page body which divides itself horizontally
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
                child: ListView(children: [
                  _buildDigestWorkingTime(),
                  DailyTimeline(),
                  MachineWorkingTimeList()
                ]))),
      ]);

  AspectRatio _buildDigestWorkingTime() => AspectRatio(
      aspectRatio: 1.3,
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
