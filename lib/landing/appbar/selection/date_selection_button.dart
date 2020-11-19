import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/components/calendar_page.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:intl/intl.dart';
import 'package:groundvisual_flutter/extensions/date_time.dart';

class DateSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDay) {
          return FlatButton.icon(
            height: 20,
            icon: Icon(Icons.add_alarm, size: 16),
            label: Text(
              state.date.sameDate(DateTime.now())
                  ? "Today"
                  : DateFormat('MM/dd/yyyy').format(state.date),
              style: Theme.of(context).textTheme.caption,
            ),
            textColor: Theme.of(context).textTheme.caption.color,
            padding: EdgeInsets.all(0),
            color: null,
            onPressed: () {
              _buildCalendarPage(context, state);
            },
          );
        } else {
          return null;
        }
      });

  void _buildCalendarPage(BuildContext context, SelectedSiteAtDay state) {
    // void action

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        builder: (_) => _calenderSelection(context, state.date, (DateTime t) {
              BlocProvider.of<SelectedSiteBloc>(context).add(DaySelected(t));
            }));
  }

  Container _calenderSelection(
    BuildContext context,
    DateTime initialSelectedDate,
    Function(DateTime t) f,
  ) =>
      Container(
        height: 500,
        color: Theme.of(context).colorScheme.background,
        child: CalendarPage(
            confirmSelectedDateAction: f,
            initialSelectedDate: initialSelectedDate),
      );
}
