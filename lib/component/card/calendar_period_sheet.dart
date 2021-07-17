import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:groundvisual_flutter/extensions/date.dart';

import '../buttons/cancel_button.dart';
import '../buttons/confirm_button.dart';

/// RDS Calendar sheet for selecting a certain date, or a date range,
/// and execute an action upon the confirmation of date or range selection.
class CalendarPeriodSheet extends StatefulWidget {
  CalendarPeriodSheet({
    Key? key,
    this.initialSelectedDate,
    this.title,
  }) : super(key: key);

  final String? title;
  final DateTime? initialSelectedDate;

  @override
  _CalendarPeriodSheetState createState() =>
      _CalendarPeriodSheetState(initialSelectedDate ?? Date.today);
}

class _CalendarPeriodSheetState extends State<CalendarPeriodSheet>
    with TickerProviderStateMixin {
  DateTime? _selectedDay;
  TrendPeriod? _selectedPeriod;
  Color? _highlightedSelectedDateRangeColor;
  late RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  late DateTime _focusedDay;

  _CalendarPeriodSheetState(this._selectedDay) {
    _focusedDay = _selectedDay ?? Date.today;
    _highlightedSelectedDateRangeColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: ListView(children: [
            SizedBox(height: 40),
            if (widget.title != null) _buildTitle(),
            SizedBox(height: 20),
            _buildSelectedDateRange(),
            Divider(thickness: 2),
            _buildSubtitle("Trend"),
            _buildPeriodSelector(),
            SizedBox(height: 20),
            _buildSubtitle("Date"),
            _buildTableCalendar()
          ])),
          Divider(thickness: 2),
          SizedBox(height: 10),
          _buildButtons(),
          SizedBox(height: 30),
        ],
      );

  Padding _buildTitle() => Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        widget.title ?? "",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.left,
      ));

  Widget _buildSubtitle(String text) => Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.left,
      ));

  Widget _buildSelectedDateRange() => Row(children: [
        AnimatedContainer(
          margin: EdgeInsets.only(left: 20, bottom: 30),
          decoration: BoxDecoration(
              color: _highlightedSelectedDateRangeColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          duration: Duration(milliseconds: 500),
          child: Text(_getSelectedDateRangeText(),
              style: Theme.of(context).textTheme.subtitle1),
        ),
        Spacer()
      ]);

  String _getSelectedDateRangeText() {
    if (_selectedDay != null)
      return _selectedDay?.toShortString() ?? Date.today.toShortString();
    else if (_selectedPeriod != null)
      return Date.today
          .subDays(_selectedPeriod?.days ?? TrendPeriod.oneWeek.days)
          .toStartEndDateString(Date.today);
    else
      return "";
  }

  Widget _buildPeriodSelector() => ConstrainedBox(
      constraints: new BoxConstraints(
        maxHeight: 30.0,
      ),
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: TrendPeriod.values
              .map((period) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                      style: period == _selectedPeriod
                          ? _highlightedPeriodButtonStyle
                          : _normalPeriodButtonStyle,
                      onPressed: () async {
                        await _highlightSelectedPeriod(period);
                        // await
                      },
                      child: Text(period.value()))))
              .toList()));

  Future<void> _highlightSelectedPeriod(TrendPeriod period) async {
    setState(() {
      _selectedPeriod = period;
      _selectedDay = null;
      _highlightedSelectedDateRangeColor =
          Theme.of(context).colorScheme.primary;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _highlightedSelectedDateRangeColor = Colors.transparent;
    });
  }

  ButtonStyle get _normalPeriodButtonStyle => OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        side: BorderSide(
            width: 2, color: Theme.of(context).colorScheme.onSurface),
      );

  ButtonStyle get _highlightedPeriodButtonStyle => OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      side: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.surface);

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
        onDaySelected: _highlightSelectedDay,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        rangeSelectionMode: _rangeSelectionMode,
      ));

  Future<void> _highlightSelectedDay(selectedDay, focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _selectedPeriod = null;
      _focusedDay = focusedDay;
      _highlightedSelectedDateRangeColor =
          Theme.of(context).colorScheme.primary;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _highlightedSelectedDateRangeColor = Colors.transparent;
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
                    if (selectedDay != null)
                      Navigator.of(context).pop(DateTimeRange(
                          start: selectedDay.startOfDay,
                          end: selectedDay.endOfDay.subMilliseconds(1)));
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
