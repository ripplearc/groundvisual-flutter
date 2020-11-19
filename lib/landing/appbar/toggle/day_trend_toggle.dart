import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DateTrendToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtWindow) {
          return _DateTrendToggle(initialIndex: 1);
        } else {
          return _DateTrendToggle(initialIndex: 0);
        }
      });
}

class _DateTrendToggle extends StatelessWidget {
  final int initialIndex;

  const _DateTrendToggle({Key key, this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) => ToggleSwitch(
        minWidth: 55.0,
        minHeight: 20.0,
        iconSize: 12,
        fontSize: 12,
        cornerRadius: 20.0,
        initialLabelIndex: initialIndex,
        activeBgColor: Theme.of(context).colorScheme.primary,
        activeFgColor: Theme.of(context).colorScheme.background,
        inactiveBgColor: Theme.of(context).colorScheme.surface,
        inactiveFgColor: Theme.of(context).textTheme.bodyText1.color,
        labels: ['Date', 'Trend'],
        onToggle: (index) => _triggerSelectSiteDateTimeEvent(index, context),
      );

  void _triggerSelectSiteDateTimeEvent(int index, BuildContext context) {
    if (index == 0) {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(DateSelected(DateTime.now()));
    } else {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(TrendSelected(LengthOfTrendAnalysis.oneWeek));
    }
  }
}
