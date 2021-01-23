import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/components/buttons/date_button.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';

/// Select a period to display the information about the selected site. It selects
/// the last 7 days by default, and it resets to last 7 days when toggle between sites,
/// or between date and trend. Once a new period is selected, it updates the <SelectedSiteBloc>.
class TrendPeriodSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          buildWhen: (previous, current) => current is SelectedSiteAtTrend,
          builder: (context, state) => state is SelectedSiteAtTrend
              ? DateButton(
                  dateText: state.period.value(),
                  action: () {
                    _buildTrendWindowSelection(
                      context,
                      state.period,
                      (TrendPeriod period) {
                        if (period == state.period) return;
                        BlocProvider.of<SelectedSiteBloc>(context)
                            .add(TrendSelected(period, context));
                      },
                    );
                  })
              : Container());

  void _buildTrendWindowSelection(
    BuildContext context,
    TrendPeriod currentPeriod,
    Function(TrendPeriod period) action,
  ) =>
      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          builder: (_) => Container(
                height: 350,
                color: Theme.of(context).colorScheme.background,
                child: ListView(
                  children: [_buildHeaderTile(context)] +
                      TrendPeriod.values.map((item) {
                        if (item == currentPeriod) {
                          return _buildHighlightListTile(item, context);
                        } else {
                          return _buildNormalListTile(item, context, action);
                        }
                      }).toList(),
                ),
              ));

  ListTile _buildHeaderTile(BuildContext context) => ListTile(
        title: Text("Trend Period",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5),
        contentPadding: EdgeInsets.all(20),
      );

  ListTile _buildHighlightListTile(
    TrendPeriod item,
    BuildContext context,
  ) =>
      ListTile(
        title: Text(
          item.value(),
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .apply(color: Theme.of(context).colorScheme.primary),
        ),
        trailing: Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      );

  ListTile _buildNormalListTile(
    TrendPeriod item,
    BuildContext context,
    Function(TrendPeriod period) action,
  ) =>
      ListTile(
        title: Text(item.value(), style: Theme.of(context).textTheme.subtitle1),
        onTap: () {
          action(item);
          Navigator.of(context).pop();
        },
      );
}
