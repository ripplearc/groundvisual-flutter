extension HourMinute on DateTime {
  String toHourMinuteString() =>
      hour.toString() + (minute == 0 ? ":0" : ":") + minute.toString();
}
