import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_slide_show.dart';
import 'package:groundvisual_flutter/landing/machine/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';

/// the body of the landing page consists of a few widgets.
class LandingHomePageBody extends StatelessWidget {
  final _key = GlobalKey<SliverAnimatedListState>();
  final builder = _SliverBuilder();

  @override
  Widget build(BuildContext context) => BlocConsumer<SelectedSiteBloc,
          SelectedSiteState>(
      listenWhen: (prev, current) => _toggleBetweenDateAndTrend(prev, current),
      listener: (context, state) => _animateRemovalOrInsertionOfWidget(state),
      builder: (context, state) => SliverAnimatedList(
          key: _key,
          initialItemCount: builder.numberOfWidgetsAtDate,
          itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) =>
              builder.buildItem(animation, state.runtimeType, index, context)));

  bool _toggleBetweenDateAndTrend(
          SelectedSiteState prev, SelectedSiteState current) =>
      (prev is SelectedSiteAtDate && current is SelectedSiteAtTrend ||
          prev is SelectedSiteAtTrend && current is SelectedSiteAtDate);

  void _animateRemovalOrInsertionOfWidget(SelectedSiteState state) {
    if (state is SelectedSiteAtTrend) {
      _key.currentState.removeItem(
          builder.dailyDigestIndex,
          (context, animation) => builder.buildItem(animation,
              SelectedSiteAtDate, builder.dailyDigestIndex, context));
    } else {
      _key.currentState.insertItem(builder.dailyDigestIndex);
    }
  }

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
  Widget buildItem(
          Animation animation, Type type, int index, BuildContext context) =>
      SlideTransition(
          position: animation
              .drive(CurveTween(curve: Curves.easeIn))
              .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))),
          child: getItem(type, index, context));

  int get dailyDigestIndex => 2;

  int get numberOfWidgetsAtDate => 4;

  Widget getItem(Type type, int index, BuildContext context) =>
      type == SelectedSiteAtDate
          ? _getItemAtDateMode(index, context)
          : _getItemAtTrendMode(index, context);

  Widget _getItemAtDateMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneMapCard();
      case 1:
        return WorkingTimeChart();
      case 2:
        return DailyDigestSlideShow();
      case 3:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }

  Widget _getItemAtTrendMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneMapCard();
      case 1:
        return WorkingTimeChart();
      case 2:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }
}
