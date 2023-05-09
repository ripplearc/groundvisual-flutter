import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/buttons/cancel_button.dart';
import 'package:groundvisual_flutter/component/buttons/confirm_button.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';

typedef OnSelectedTrendAction(TrendPeriod period);

/// RDS Period sheet for selecting a certain period, and execute an action
/// upon a period selection.
class PeriodSheet extends StatefulWidget {
  final TrendPeriod? initialPeriod;
  final String? title;

  const PeriodSheet({Key? key, this.initialPeriod, this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PeriodSheetState();
}

class PeriodSheetState extends State<PeriodSheet> {
  final _leadingPadding = 10.0;
  TrendPeriod _selectedPeriod = TrendPeriod.oneWeek;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.initialPeriod ?? TrendPeriod.oneWeek;
  }

  @override
  Widget build(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
            SizedBox(height: 40),
            _buildHeaderTile(context),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 30),
              child: Text(
                  Date.today
                      .subDays(_selectedPeriod.days)
                      .toStartEndDateString(Date.today),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Divider(thickness: 2),
          ] +
          TrendPeriod.values.map((item) {
            if (item == _selectedPeriod) {
              return _buildHighlightListTile(item, context);
            } else {
              return _buildNormalListTile(item, context);
            }
          }).toList() +
          [
            Spacer(),
            Divider(thickness: 2),
            SizedBox(height: 10),
            _buildButtons(),
            SizedBox(height: 20)
          ]);

  Widget _buildHeaderTile(BuildContext context) => Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        widget.title ?? "",
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.left,
      ));

  ListTile _buildHighlightListTile(
    TrendPeriod item,
    BuildContext context,
  ) =>
      ListTile(
        title: Padding(
          padding: EdgeInsets.only(left: _leadingPadding),
          child: Text(item.value(),
              style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.apply(color: Theme.of(context).colorScheme.primary) ??
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        trailing: Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.primary,
        ),
      );

  ListTile _buildNormalListTile(TrendPeriod item, BuildContext context) =>
      ListTile(
        title: Padding(
          padding: EdgeInsets.only(left: _leadingPadding),
          child:
              Text(item.value(), style: Theme.of(context).textTheme.titleMedium),
        ),
        onTap: () {
          setState(() {
            _selectedPeriod = item;
          });
        },
      );

  Row _buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ConfirmButton(confirmAction: () async {
                    Navigator.of(context).pop(_selectedPeriod);
                  }))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CancelButton(cancelAction: () {
                    Navigator.pop(context);
                  })))
        ],
      );
}
