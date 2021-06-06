import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

extension ToString on DateTime {
  String toHourMinuteString() =>
      hour.toString() + (minute == 0 ? ":0" : ":") + minute.toString();

  String toShortString() => isSameDay(DateTime.now())
      ? 'Today'
      : isSameYear(DateTime.now())
          ? DateFormat('MMM dd').format(this)
          : DateFormat('MMM dd,yyyy').format(this);

  String toStartEndDateString(DateTime endDate) => isSameDay(endDate)
      ? toShortString()
      : isSameMonth(endDate)
          ? toShortString() + " - " + DateFormat('dd').format(endDate)
          : toShortString() + " - " + endDate.toShortString();
}
