import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/document/work_zone_composite_card.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/working_time_chart.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_card.dart';

class DocumentHomePageBody extends StatelessWidget {
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

  int get numberOfWidgetsAtDate => 2;

  Widget getItem(Type type, int index, BuildContext context) =>
      type == SelectedSiteAtDate
          ? _getItemAtDateMode(index, context)
          : _getItemAtTrendMode(index, context);

  Widget _getItemAtDateMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneCompositeCard();
      case 1:
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
