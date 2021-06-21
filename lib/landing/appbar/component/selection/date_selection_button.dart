import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

typedef _OnTapAction = Future<DateTimeRange?> Function(
    BuildContext context, SelectedSiteAtDate state);

/// Select a date to display information about the current site. By default it selects today,
/// and it doesn't allow to select the future. It resets to today when toggles between sites,
/// or between date and trend. Once a new date is selected, it updates the <SelectedSiteBloc>.
class DateSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScreenTypeLayout.builder(
        mobile: (_) => _buildCalendarButton(_showBottomSheet),
        tablet: (_) => _buildCalendarButton(_showMaterialDialog),
        desktop: (_) => _buildCalendarButton(_showMaterialDialog),
      );

  _buildCalendarButton(_OnTapAction onTapAction) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          buildWhen: (prev, current) => current is SelectedSiteAtDate,
          builder: (context, state) => state is SelectedSiteAtDate
              ? DateButton(
                  iconSize: 12,
                  textStyle: Theme.of(context).textTheme.caption,
                  dateText: state.date.toShortString(),
                  action: () async {
                    final range = await onTapAction(context, state);
                    range?.let(
                        (it) => _onDateSelected(state, it.start, context));
                  },
                )
              : Container());

  Future<DateTimeRange?> _showBottomSheet(
          BuildContext scaffoldContext, SelectedSiteAtDate state) =>
      showModalBottomSheet<DateTimeRange>(
          context: scaffoldContext,
          isScrollControlled: true,
          backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
          builder: (_) =>
              _buildCalenderInBottomSheet(state.date, state.siteName));

  Widget _buildCalenderInBottomSheet(
    DateTime initialSelectedDate,
    String title,
  ) =>
      CalendarSheet(initialSelectedDate: initialSelectedDate, title: title);

  Future<DateTimeRange?> _showMaterialDialog(
          BuildContext scaffoldContext, SelectedSiteAtDate state) =>
      showDialog<DateTimeRange>(
          context: scaffoldContext,
          builder: (_) => SimpleDialog(
                backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
                children: [_buildCalenderInDialog(state.date)],
              ));

  Widget _buildCalenderInDialog(DateTime initialSelectedDate) => Container(
        height: 600,
        width: 500,
        child: CalendarSheet(initialSelectedDate: initialSelectedDate),
      );

  void _onDateSelected(
      SelectedSiteAtDate state, DateTime? t, BuildContext context) {
    if (t == null || state.date.isSameDay(t)) return;
    BlocProvider.of<SelectedSiteBloc>(context).add(DateSelected(t, context));
  }
}
