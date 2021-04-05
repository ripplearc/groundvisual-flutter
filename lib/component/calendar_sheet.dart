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
      {Key? key, this.confirmSelectedDateAction, this.initialSelectedDate})
      : super(key: key);

  final DateTime? initialSelectedDate;
  final ConfirmSelectedDateAction? confirmSelectedDateAction;

  @override
  _CalendarSheetState createState() =>
      _CalendarSheetState(/*initialSelectedDate ??*/
          Date.startOfToday.subtract(Duration(days: 2)));
}

class _CalendarSheetState extends State<CalendarSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  DateTime _selectedDate;
  late DateTime _focusedDate;

  _CalendarSheetState(this._selectedDate) {
    _focusedDate = _selectedDate;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(selectedDay, focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
    });
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

  TableCalendar _buildTableCalendar(BuildContext context) => TableCalendar(
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now(),
        focusedDay: _focusedDate,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        calendarStyle: _buildCalendarStyle(context),
        headerStyle: _buildHeaderStyle(context),
        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          _focusedDate = focusedDay;
        },
      );

  HeaderStyle _buildHeaderStyle(BuildContext context) => HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: Theme.of(context).colorScheme.onBackground),
      );

  CalendarStyle _buildCalendarStyle(BuildContext context) => CalendarStyle(
      selectedDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      weekendTextStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.apply(color: Theme.of(context).colorScheme.secondaryVariant) ??
          TextStyle(color: Theme.of(context).colorScheme.secondaryVariant),
      todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle),
      todayTextStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      disabledTextStyle: Theme.of(context)
              .textTheme
              .subtitle1
              ?.apply(color: Theme.of(context).colorScheme.onSurface) ??
          TextStyle(color: Theme.of(context).colorScheme.onSurface));

  Row _buildButtons(BuildContext context, Function(DateTime t)? f) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ConfirmButton(confirmAction: () {
                widget.confirmSelectedDateAction?.call(_selectedDate);
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
