import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/components/calendar_page.dart';
import 'package:groundvisual_flutter/components/buttons/date_button.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/extensions/date_time.dart';
import 'package:intl/intl.dart';

class DateSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) => state is SelectedSiteAtDate
              ? DateButton(
                  dateText: state.date.sameDate(DateTime.now())
                      ? 'Today'
                      : DateFormat('MM/dd/yyyy').format(state.date),
                  action: () {
                    _buildCalendarPage(context, state);
                  },
                )
              : null);

  void _buildCalendarPage(BuildContext context, SelectedSiteAtDate state) =>
      showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          builder: (_) => _calenderSelection(context, state.date, (DateTime t) {
                BlocProvider.of<SelectedSiteBloc>(context).add(DateSelected(t));
              }));

  Container _calenderSelection(
    BuildContext context,
    DateTime initialSelectedDate,
    Function(DateTime t) action,
  ) =>
      Container(
        height: 500,
        color: Theme.of(context).colorScheme.background,
        child: CalendarPage(
            confirmSelectedDateAction: action,
            initialSelectedDate: initialSelectedDate),
      );
}
