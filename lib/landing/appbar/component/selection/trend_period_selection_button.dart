import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/period_sheet.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/date_selection_button.dart';

/// Select a period to display the information about the selected site. It selects
/// the last 7 days by default, and it resets to last 7 days when toggle between sites,
/// or between date and trend. Once a new period is selected, it updates the <SelectedSiteBloc>.
/// See also [DateSelectionButton].
class TrendPeriodSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _buildTrendButton();

  _buildTrendButton() => BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
      buildWhen: (previous, current) => current is SelectedSiteAtTrend,
      builder: (context, state) => state is SelectedSiteAtTrend
          ? DateButton(
              iconSize: 12,
              textStyle: Theme.of(context).textTheme.bodySmall,
              dateText: state.period.value(),
              action: () async {
                final period =
                    await _buildTrendWindowSelectionInDialog(context, state);
                _onTrendSelected(period ?? TrendPeriod.oneWeek, state, context);
              })
          : Container());

  Future<TrendPeriod?> _buildTrendWindowSelectionInDialog(
          BuildContext scaffoldContext, SelectedSiteAtTrend state) =>
      showDialog(
          context: scaffoldContext,
          builder: (_) => SimpleDialog(
                  backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
                  children: [
                    Container(
                        width: 400,
                        height: 600,
                        child: PeriodSheet(
                          title: state.siteName,
                          initialPeriod: state.period,
                        ))
                  ]));

  void _onTrendSelected(
      TrendPeriod period, SelectedSiteAtTrend state, BuildContext context) {
    if (period == state.period) return;
    BlocProvider.of<SelectedSiteBloc>(context)
        .add(TrendSelected(period, context));
  }
}
