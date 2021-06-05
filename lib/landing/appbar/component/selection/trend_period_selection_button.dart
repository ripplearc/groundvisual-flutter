import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/period_sheet.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef _OnTapAction(BuildContext context, SelectedSiteAtTrend state);

/// Select a period to display the information about the selected site. It selects
/// the last 7 days by default, and it resets to last 7 days when toggle between sites,
/// or between date and trend. Once a new period is selected, it updates the <SelectedSiteBloc>.
class TrendPeriodSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (_) =>
            _buildTrendButton(_buildTrendWindowSelectionInBottomSheet),
        tablet: (_) => _buildTrendButton(_buildTrendWindowSelectionInDialog),
        desktop: (_) => _buildTrendButton(_buildTrendWindowSelectionInDialog),
      );

  _buildTrendButton(_OnTapAction onTapAction) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          buildWhen: (previous, current) => current is SelectedSiteAtTrend,
          builder: (context, state) => state is SelectedSiteAtTrend
              ? DateButton(
                  iconSize: 12,
                  textStyle: Theme.of(context).textTheme.caption,
                  dateText: state.period.value(),
                  action: () {
                    onTapAction(context, state);
                  })
              : Container());

  void _buildTrendWindowSelectionInBottomSheet(
          BuildContext context, SelectedSiteAtTrend state) =>
      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).cardTheme.color,
          builder: (_) => Container(
              height: 350,
              child: PeriodSheet(
                initialPeriod: state.period,
                onSelectedTrendAction: (TrendPeriod period) {
                  _onTrendSelected(period, state, context);
                },
              )));

  void _buildTrendWindowSelectionInDialog(
          BuildContext scaffoldContext, SelectedSiteAtTrend state) =>
      showDialog(
          context: scaffoldContext,
          builder: (_) => SimpleDialog(
                  backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
                  children: [
                    Container(
                        width: 300,
                        height: 330,
                        child: PeriodSheet(
                          initialPeriod: state.period,
                          onSelectedTrendAction: (TrendPeriod period) {
                            _onTrendSelected(period, state, scaffoldContext);
                          },
                        ))
                  ]));

  void _onTrendSelected(
      TrendPeriod period, SelectedSiteAtTrend state, BuildContext context) {
    if (period == state.period) return;
    BlocProvider.of<SelectedSiteBloc>(context)
        .add(TrendSelected(period, context));
  }
}
