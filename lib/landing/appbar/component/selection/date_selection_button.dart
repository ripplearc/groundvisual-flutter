import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/component/dialog/dialog_config.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';

/// Select a date to display information about the current site. By default it selects today,
/// and it doesn't allow to select the future. It resets to today when toggles between sites,
/// or between date and trend. Once a new date is selected, it updates the <SelectedSiteBloc>.
class DateSelectionButton extends StatelessWidget with WebDialogConfig {
  @override
  Widget build(BuildContext context) => _buildCalendarButton();

  _buildCalendarButton() => BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
      buildWhen: (prev, current) => current is SelectedSiteAtDate,
      builder: (context, state) => state is SelectedSiteAtDate
          ? DateButton(
              iconSize: 12,
              textStyle: Theme.of(context).textTheme.caption,
              dateText: state.date.toShortString(),
              action: () async {
                final range = await _showMaterialDialog(context, state);
                range?.let((it) => _onDateSelected(state, it.start, context));
              },
            )
          : Container());

  Future<DateTimeRange?> _showMaterialDialog(
          BuildContext scaffoldContext, SelectedSiteAtDate state) =>
      showDialog<DateTimeRange>(
          context: scaffoldContext,
          builder: (_) => SimpleDialog(
                backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
                children: [_buildCalenderInDialog(state.date, state.siteName)],
              ));

  Widget _buildCalenderInDialog(DateTime initialSelectedDate, String title) =>
      Container(
        height: webDialogHeight,
        width: webDialogWidth,
        child: CalendarSheet(
            title: title, initialSelectedDate: initialSelectedDate),
      );

  void _onDateSelected(
      SelectedSiteAtDate state, DateTime? t, BuildContext context) {
    if (t == null || state.date.isSameDay(t)) return;
    BlocProvider.of<SelectedSiteBloc>(context).add(DateSelected(t, context));
  }
}
