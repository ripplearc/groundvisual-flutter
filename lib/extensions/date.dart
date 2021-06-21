import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ToString on DateTime {
  String toHourMinuteString() =>
      hour.toString() + (minute == 0 ? ":0" : ":") + minute.toString();

  String toShortString({bool spellOutToday = true}) =>
      isSameDay(DateTime.now()) && spellOutToday
          ? 'Today'
          : isSameYear(DateTime.now())
              ? DateFormat('MMM dd').format(this)
              : DateFormat('MMM dd,yyyy').format(this);

  String toStartEndDateString(DateTime endDate) => isSameDay(endDate)
      ? toShortString()
      : isSameMonth(endDate)
          ? toShortString() + " - " + DateFormat('dd').format(endDate)
          : toShortString() +
              " - " +
              endDate.toShortString(spellOutToday: false);
}

extension ToTimeString on DateTimeRange {
  String get toTimeRangeString {
    final startTime = TimeOfDay.fromDateTime(start);
    final endTime = TimeOfDay.fromDateTime(end);
    return start.isSameDay(end)
        ? "${_addLeadingZeroIfNeeded(startTime.hour)}:${_addLeadingZeroIfNeeded(startTime.minute)}" +
            " - ${_addLeadingZeroIfNeeded(endTime.hour)}:${_addLeadingZeroIfNeeded(endTime.minute)}"
        : "Not Same Day";
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }
}
