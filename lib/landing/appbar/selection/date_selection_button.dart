import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/components/calendar_page.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:intl/intl.dart';

class DateSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDay) {
          String date = "";
          if (state.date.year == DateTime.now().year &&
              state.date.month == DateTime.now().month &&
              state.date.day == DateTime.now().day) {
            date = "Today";
          } else {
            date = DateFormat('MM/dd/yyyy').format(state.date);
          }
          return FlatButton.icon(
            height: 20,
            icon: Icon(
              Icons.add_alarm,
              size: 16,
            ),
            label: Text(
              date,
              style: Theme.of(context).textTheme.caption,
            ),
            textColor: Theme.of(context).textTheme.caption.color,
            padding: EdgeInsets.all(0),
            color: null,
            onPressed: () {
              void confirmDay(DateTime t) =>
                  BlocProvider.of<SelectedSiteBloc>(context)
                      .add(DaySelected(t));
              showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  builder: (BuildContext context) =>
                      _calenderSelection(context, confirmDay, state.date));
            },
          );
        } else {
          return null;
        }
      });

  Container _calenderSelection(BuildContext context, Function(DateTime t) f,
          DateTime initialSelectedDate) =>
      Container(
        height: 500,
        color: Theme.of(context).colorScheme.background,
        child: CalendarPage(
            confirmSelectedDateAction: f, initialSelectedDate: initialSelectedDate),
      );
}
