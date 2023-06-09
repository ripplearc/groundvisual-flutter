import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_embedded_chart.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/widget/daily_timeline.dart';

import '../component/digest_working_time_composite_content.dart';
import 'composite/work_zone_composite_card.dart';

/// the body of the landing page consists of a few widgets.

class LandingHomePageMobileBody extends StatelessWidget {
  final _key = GlobalKey<SliverAnimatedListState>();
  final builder = _SliverBuilder();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) => SliverAnimatedList(
              key: _key,
              initialItemCount: builder.numberOfWidgets,
              itemBuilder: (BuildContext context, int index,
                      Animation<double> animation) =>
                  builder.buildItem(
                      animation, state.runtimeType, index, context)));
}

/// Build the slivers based on the current SelectedSiteState
class _SliverBuilder {
  final double embeddedTrendContentAspectRatio = 1.8;
  final double embeddedDailyContentAspectRatio = 1.3;
  final int numberOfWidgets = 3;

  Widget buildItem(
          Animation animation, Type type, int index, BuildContext context) =>
      SlideTransition(
          position: animation
              .drive(CurveTween(curve: Curves.easeIn))
              .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))),
          child: _getItem(type, index, context));

  Widget _getItem(Type type, int index, BuildContext context) =>
      type == SelectedSiteAtDate
          ? _getItemAtDateMode(index, context)
          : _getItemAtTrendMode(index, context);

  Widget _getItemAtDateMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneCompositeCard(
            embeddedContentAspectRatio: embeddedDailyContentAspectRatio,
            embeddedContent: DigestWorkingZoneCompositeContent());
      case 1:
        return DailyTimeline();
      case 2:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }

  Widget _getItemAtTrendMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneCompositeCard(
            embeddedContentAspectRatio: embeddedTrendContentAspectRatio,
            embeddedContent: WorkingTimeEmbeddedChart(
                aspectRatio: embeddedTrendContentAspectRatio));
      case 1:
        return DailyTimeline();
      case 2:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }
}
