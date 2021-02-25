import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/work_zone_composite_card.dart';
import 'package:groundvisual_flutter/landing/chart/date/work_zone_daily_embedded_content.dart';
import 'package:groundvisual_flutter/landing/chart/trend/work_zone_trend_embedded_content.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';

/// the body of the landing page consists of a few widgets.

class LandingHomePageBody extends StatelessWidget {
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

  void _tapDetail(BuildContext context, FluroRouter router, String key) {
    String message = "";
    String hexCode = "#FFFFFF";
    TransitionType transitionType = TransitionType.native;
    hexCode = "#F76F00";
    message =
    "This screen should have appeared using the default flutter animation for the current OS";
    transitionType = TransitionType.inFromRight;

    String route = "/site/detail?message=$message&color_hex=$hexCode";

    router
        .navigateTo(context, route, transition: transitionType)
        .then((result) {
      if (key == "pop-result") {
        router.navigateTo(context, "/demo/func?message=$result");
      }
    });
  }
}

/// Build the slivers based on the current SelectedSiteState, and animate
/// the removal or insertion of the widget.
class _SliverBuilder {
  final double embeddedTrendContentAspectRatio = 1.8;
  final double embeddedDailyContentAspectRatio = 1.3;
  final int numberOfWidgets = 2;

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
            embeddedContent: WorkZoneDailyEmbeddedContent());
      case 1:
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
            embeddedContent: WorkZoneTrendEmbeddedContent(
                chartCardAspectRatio: embeddedTrendContentAspectRatio));
      case 1:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }
}
