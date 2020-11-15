import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DayTrendToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtWindow) {
          return _DayTrendToggle(initalIndex: 1);
        } else {
          return _DayTrendToggle(initalIndex: 0);
        }
      });
}

class _DayTrendToggle extends StatelessWidget {
  final int initalIndex;

  const _DayTrendToggle({Key key, this.initalIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) => ToggleSwitch(
        minWidth: 55.0,
        minHeight: 20.0,
        iconSize: 12,
        fontSize: 12,
        cornerRadius: 20.0,
        initialLabelIndex: initalIndex,
        activeBgColor: Theme.of(context).colorScheme.primary,
        activeFgColor: Colors.white,
        inactiveBgColor: Theme.of(context).colorScheme.onBackground,
        inactiveFgColor: Colors.white,
        labels: ['Day', 'Trend'],
        onToggle: (index) => _triggerSelectSiteDateTimeEvent(index, context),
      );

  void _triggerSelectSiteDateTimeEvent(int index, BuildContext context) {
    if (index == 0) {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(DaySelected(DateTime.now()));
    } else {
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(TrendSelected(LengthOfTrendAnalysis.oneWeek));
    }
  }
}