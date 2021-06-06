import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/buttons/toggle_button.dart';
import 'package:table_calendar/table_calendar.dart';

import 'buttons/cancel_button.dart';
import 'buttons/confirm_button.dart';

typedef ConfirmSelectedDateAction(DateTime t);
typedef ConfirmSelectedDateRangeAction(DateTime start, DateTime end);

/// RDS Calendar sheet for selecting a certain date, or a date range,
/// and execute an action upon the confirmation of date or range selection.
class CalendarSheet extends StatefulWidget {
  CalendarSheet({
    Key? key,
    this.confirmSelectedDateAction,
    this.confirmSelectedDateRangeAction,
    this.initialSelectedDate,
    this.initialSelectedDateRange,
    this.allowRangeSelection = false,
  }) : super(key: key);

  final bool allowRangeSelection;
  final DateTime? initialSelectedDate;
  final DateTimeRange? initialSelectedDateRange;
  final ConfirmSelectedDateAction? confirmSelectedDateAction;
  final ConfirmSelectedDateRangeAction? confirmSelectedDateRangeAction;

  @override
  _CalendarSheetState createState() => _CalendarSheetState(
      initialSelectedDate ?? Date.today, initialSelectedDateRange);
}

class _CalendarSheetState extends State<CalendarSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int _toggleIndex = 0;
  late RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  late DateTime _focusedDay;

  _CalendarSheetState(this._selectedDay, DateTimeRange? dateRange) {
    _focusedDay = _selectedDay ?? Date.today;
    _rangeStart = dateRange?.start;
    _rangeEnd = dateRange?.end;
    _toggleIndex = _rangeStart == null ? 0 : 1;
    _rangeSelectionMode = _rangeStart == null
        ? RangeSelectionMode.disabled
        : RangeSelectionMode.enforced;
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

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (widget.allowRangeSelection) _buildDateRangeToggle(),
          _buildTableCalendar(),
          _buildButtons(null),
        ],
      );

  ToggleButton _buildDateRangeToggle() => ToggleButton(
      key: UniqueKey(),
      initialIndex: _toggleIndex,
      labels: ["Date", "Range"],
      widthPercent: 50,
      height: 35,
      toggleAction: (index) {
        setState(() {
          _toggleIndex = index;
          if (index == 0) {
            _rangeStart = null;
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.disabled;
          } else {
            _selectedDay = null;
            _rangeSelectionMode = RangeSelectionMode.enforced;
          }
        });
      });

  TableCalendar _buildTableCalendar() => TableCalendar(
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        calendarStyle: _buildCalendarStyle(),
        headerStyle: _buildHeaderStyle(),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        onRangeSelected: _onRangeSelected,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: _rangeSelectionMode,
      );

  void _onRangeSelected(start, end, focusedDay) {
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = focusedDay;
    });
  }

  void _onDaySelected(selectedDay, focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  HeaderStyle _buildHeaderStyle() => HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: Theme.of(context).colorScheme.onBackground),
      );

  CalendarStyle _buildCalendarStyle() => CalendarStyle(
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

  Row _buildButtons(Function(DateTime t)? f) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ConfirmButton(confirmAction: () {
                final selectedDay = _selectedDay;
                final rangeStart = _rangeStart;
                final rangeEnd = _rangeEnd;
                if (_rangeSelectionMode == RangeSelectionMode.disabled &&
                    selectedDay != null)
                  widget.confirmSelectedDateAction?.call(selectedDay);
                else if (rangeStart != null && rangeEnd != null)
                  widget.confirmSelectedDateRangeAction
                      ?.call(rangeStart, rangeEnd);
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
