extension Comparison on DateTime {
  bool isSameDate(DateTime date) {
    return date.year == this.year &&
        date.month == this.month &&
        date.day == this.day;
  }
}
