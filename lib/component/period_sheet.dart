import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';

typedef OnSelectedTrendAction(TrendPeriod period);

/// RDS Period sheet for selecting a certain period, and execute an action
/// upon a period selection.
class PeriodSheet extends StatelessWidget {
  final TrendPeriod initialPeriod;
  final OnSelectedTrendAction onSelectedTrendAction;
  final _leadingPadding = 10.0;

  const PeriodSheet({Key key, this.initialPeriod, this.onSelectedTrendAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: [_buildHeaderTile(context)] +
            TrendPeriod.values.map((item) {
              if (item == initialPeriod) {
                return _buildHighlightListTile(item, context);
              } else {
                return _buildNormalListTile(item, context);
              }
            }).toList(),
      );

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
        title: Padding(
          padding: EdgeInsets.only(left: _leadingPadding),
          child: Text(
            item.value(),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .apply(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        trailing: Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      );

  ListTile _buildNormalListTile(TrendPeriod item, BuildContext context) =>
      ListTile(
        title: Padding(
          padding: EdgeInsets.only(left: _leadingPadding),
          child:
              Text(item.value(), style: Theme.of(context).textTheme.subtitle1),
        ),
        onTap: () {
          onSelectedTrendAction(item);
          Navigator.of(context).pop();
        },
      );
}
