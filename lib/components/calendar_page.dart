import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/components/buttons/cancel_button.dart';
import 'package:groundvisual_flutter/components/buttons/confirm_button.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage(
      {Key key, this.confirmSelectedDateAction, this.initialSelectedDate})
      : super(key: key);

  final Function(DateTime t) confirmSelectedDateAction;
  final DateTime initialSelectedDate;

  @override
  _CalendarPageState createState() =>
      _CalendarPageState(confirmSelectedDateAction, initialSelectedDate);
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDate;

  final Function(DateTime t) _confirmSelectedDateAction;

  _CalendarPageState(this._confirmSelectedDateAction, this._selectedDate);

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

  void _onDaySelected(DateTime day, List events, List holidays) {
    _selectedDate = day;
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
          .apply(color: Theme.of(context).colorScheme.primaryVariant),
      todayColor: Theme.of(context).colorScheme.primaryVariant,
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
          ConfirmButton(confirmAction: () {
            _confirmSelectedDateAction(_selectedDate);
            Navigator.pop(context);
          }),
          CancelButton(cancelAction: () {
            Navigator.pop(context);
          })
        ],
      );
}
