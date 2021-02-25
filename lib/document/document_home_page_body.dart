import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/document/work_zone_composite_card_2.dart';
import 'package:groundvisual_flutter/document/work_zone_daily_embedded_content.dart';
import 'package:groundvisual_flutter/document/work_zone_trend_embedded_content.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/widgets/machine_working_time_list.dart';

class DocumentHomePageBody extends StatelessWidget {
  final _key = GlobalKey<SliverAnimatedListState>();
  final builder = _SliverBuilder();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) => SliverAnimatedList(
              key: _key,
              initialItemCount: builder.numberOfWidgetsAtDate,
              itemBuilder: (BuildContext context, int index,
                      Animation<double> animation) =>
                  builder.buildItem(
                      animation, state.runtimeType, index, context)));
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

  int get numberOfWidgetsAtDate => 2;

  Widget getItem(Type type, int index, BuildContext context) =>
      type == SelectedSiteAtDate
          ? _getItemAtDateMode(index, context)
          : _getItemAtTrendMode(index, context);

  Widget _getItemAtDateMode(int index, BuildContext context) {
    switch (index) {
      case 0:
        return WorkZoneCompositeCardTwo(
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
        return WorkZoneCompositeCardTwo(
            embeddedContentAspectRatio: 1.8,
            embeddedContent:
                WorkZoneTrendEmbeddedContent(chartCardAspectRatio: 1.8));
      case 1:
        return MachineWorkingTimeList();
      default:
        return Container();
    }
  }
}
