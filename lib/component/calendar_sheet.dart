import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dart_date/dart_date.dart';

import 'buttons/cancel_button.dart';
import 'buttons/confirm_button.dart';

typedef ConfirmSelectedDateAction(DateTime t);

/// RDS Calendar sheet for selecting a certain date, and execute an action
/// upon the confirmation of date selection.
class CalendarSheet extends StatefulWidget {
  CalendarSheet(
      {Key key, this.confirmSelectedDateAction, this.initialSelectedDate})
      : super(key: key);

  final DateTime initialSelectedDate;
  final ConfirmSelectedDateAction confirmSelectedDateAction;

  @override
  _CalendarSheetState createState() =>
      _CalendarSheetState(confirmSelectedDateAction, initialSelectedDate);
}

class _CalendarSheetState extends State<CalendarSheet>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDate;

  final Function(DateTime t) _confirmSelectedDateAction;

  _CalendarSheetState(this._confirmSelectedDateAction, this._selectedDate);

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date, List events, List holidays) {
    _selectedDate = date.startOfDay;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTableCalendar(context),
          _buildButtons(context, null),
        ],
      );

  TableCalendar _buildTableCalendar(BuildContext context) {
    return TableCalendar(
      endDay: DateTime.now(),
      initialSelectedDay: _selectedDate,
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      calendarStyle: _buildCalendarStyle(context),
      headerStyle: _buildHeaderStyle(context),
      onDaySelected: _onDaySelected,
    );
  }

  HeaderStyle _buildHeaderStyle(BuildContext context) => HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: Theme.of(context).colorScheme.onBackground),
      );

  CalendarStyle _buildCalendarStyle(BuildContext context) => CalendarStyle(
      selectedColor: Theme.of(context).colorScheme.primary,
      weekdayStyle: Theme.of(context).textTheme.subtitle1,
      weekendStyle: Theme.of(context)
          .textTheme
          .subtitle1
          .apply(color: Theme.of(context).colorScheme.secondaryVariant),
      todayColor: Theme.of(context).colorScheme.secondary,
      todayStyle: Theme.of(context)
          .textTheme
          .subtitle1
          .apply(color: Theme.of(context).colorScheme.background),
      selectedStyle: Theme.of(context)
          .textTheme
          .subtitle1
          .apply(color: Theme.of(context).colorScheme.background),
      outsideDaysVisible: false,
      unavailableStyle: Theme.of(context)
          .textTheme
          .subtitle1
          .apply(color: Theme.of(context).colorScheme.onSurface));

  Row _buildButtons(BuildContext context, Function(DateTime t) f) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ConfirmButton(confirmAction: () {
                _confirmSelectedDateAction(_selectedDate);
                Navigator.pop(context);
              }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: CancelButton(cancelAction: () {
                Navigator.pop(context);
              }),
            ),
          )
        ],
      );
}
