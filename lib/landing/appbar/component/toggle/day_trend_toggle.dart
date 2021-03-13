import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/component/buttons/toggle_button.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';

/// Toggle between date or trend for information about a site. Date option displays
/// the information on a certain date, while trend option displays information within
/// a certain period, e.g. the last 7 days.
class DateTrendToggle extends StatelessWidget {
  final double widthPercent;
  final double height;

  const DateTrendToggle({Key key, this.widthPercent = 30, this.height = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        final index = state is SelectedSiteAtTrend ? 1 : 0;
        return ToggleButton(
            key: UniqueKey(),
            initialIndex: index,
            labels: ["Date", "Trend"],
            widthPercent: widthPercent,
            height: height,
            toggleAction: (index) {
              _triggerSelectSiteDateTimeEvent(index, context);
            });
      });

  void _triggerSelectSiteDateTimeEvent(int index, BuildContext context) {
    if (index == 0) {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(DateSelected(DateTime.now().startOfDay, context));
    } else {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(TrendSelected(TrendPeriod.oneWeek, context));
    }
  }
}