import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/buttons/toggle_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';

import '../buttons/cancel_button.dart';
import '../buttons/confirm_button.dart';

/// RDS Calendar sheet for selecting a certain date, or a date range,
/// and execute an action upon the confirmation of date or range selection.
class CalendarSheet extends StatefulWidget {
  CalendarSheet({
    Key? key,
    this.initialSelectedDate,
    this.initialSelectedDateRange,
    this.allowRangeSelection = false,
    this.title,
  }) : super(key: key);

  final String? title;
  final bool allowRangeSelection;
  final DateTime? initialSelectedDate;
  final DateTimeRange? initialSelectedDateRange;

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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          if (widget.title != null)
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  widget.title ?? "",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.left,
                )),
          if (widget.allowRangeSelection) _buildDateRangeToggle(),
          SizedBox(height: 20),
          Divider(thickness: 2),
          SizedBox(height: 20),
          _buildTableCalendar(),
          Spacer(),
          Divider(thickness: 2),
          SizedBox(height: 10),
          _buildButtons(),
          SizedBox(height: 30),
        ],
      );

  Row _buildDateRangeToggle() => Row(
        children: [
          Spacer(),
          ToggleButton(
              key: UniqueKey(),
              initialIndex: _toggleIndex,
              labels: ["Date", "Range"],
              widthPercent: _widthPercent,
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
              }),
          Spacer()
        ],
      );

  double get _widthPercent => getValueForScreenType<double>(
        context: context,
        mobile: 50,
        tablet: 20,
        desktop: 15,
      );

  Widget _buildTableCalendar() => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TableCalendar(
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
      ));

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
              .titleMedium
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      rangeStartDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      rangeEndDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      rangeHighlightColor: Theme.of(context).colorScheme.primary.withAlpha(64),
      rangeStartTextStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      rangeEndTextStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      weekendTextStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.apply(color: Theme.of(context).colorScheme.secondaryContainer) ??
          TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
      todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle),
      todayTextStyle: Theme.of(context).textTheme.titleMedium?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      disabledTextStyle:
          Theme.of(context).textTheme.titleMedium?.apply(color: Theme.of(context).colorScheme.onSurface) ??
              TextStyle(color: Theme.of(context).colorScheme.onSurface));

  Row _buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ConfirmButton(
                  text: "Search",
                  confirmAction: () {
                    final selectedDay = _selectedDay;
                    final rangeStart = _rangeStart;
                    final rangeEnd = _rangeEnd;
                    if (_rangeSelectionMode == RangeSelectionMode.disabled &&
                        selectedDay != null)
                      Navigator.of(context).pop(DateTimeRange(
                          start: selectedDay.startOfDay,
                          end: selectedDay.endOfDay.subMilliseconds(1)));
                    else if (rangeStart != null && rangeEnd != null)
                      Navigator.of(context)
                          .pop(DateTimeRange(start: rangeStart, end: rangeEnd));
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
