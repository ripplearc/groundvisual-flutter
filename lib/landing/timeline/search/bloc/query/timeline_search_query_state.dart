part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryState extends Equatable {
  DateTimeRange get dateTimeRange;

  String get dateString =>
      dateTimeRange.start.toStartEndDateString(dateTimeRange.end);

  String get timeString;

  String get dateTimeString;

  TimeOfDay? get startTime;

  TimeOfDay? get endTime;

  bool get enableTimeEdit => dateTimeRange.start.isSameDay(dateTimeRange.end);

  String get siteName;

  Map<MachineDetail, bool> get filteredMachines;

  List<Object?> get props => [dateTimeRange, siteName, filteredMachines];
}

class TimelineSearchQueryInitial extends TimelineSearchQueryState {
  final DateTimeRange dateTimeRange;
  final Map<MachineDetail, bool> filteredMachines;
  final String siteName;

  TimelineSearchQueryInitial(
      this.dateTimeRange, this.siteName, this.filteredMachines);

  @override
  String get timeString => "Edit Time";

  @override
  TimeOfDay? get endTime => null;

  @override
  TimeOfDay? get startTime => null;

  @override
  String get dateTimeString => dateString;
}

class TimelineSearchQueryUpdate extends TimelineSearchQueryState {
  final DateTimeRange dateTimeRange;
  final Map<MachineDetail, bool> filteredMachines;
  final String siteName;
  static const String EditTime = "Edit Time";

  TimelineSearchQueryUpdate(
      this.dateTimeRange, this.filteredMachines, this.siteName);

  @override
  String get timeString => dateTimeRange.start.isSameDay(dateTimeRange.end)
      ? dateTimeRange.start.isBefore(dateTimeRange.end)
          ? dateTimeRange.toTimeRangeString
          : EditTime
      : EditTime;

  @override
  TimeOfDay? get endTime => dateTimeRange.start.isSameDay(dateTimeRange.end)
      ? dateTimeRange.start.isEqual(dateTimeRange.end)
          ? null
          : TimeOfDay.fromDateTime(dateTimeRange.end)
      : null;

  @override
  TimeOfDay? get startTime => dateTimeRange.start.isSameDay(dateTimeRange.end)
      ? dateTimeRange.start.isEqual(dateTimeRange.end)
          ? null
          : TimeOfDay.fromDateTime(dateTimeRange.start)
      : null;

  @override
  String get dateTimeString =>
      dateString  + (timeString != EditTime ? "  |  " + timeString : "");
}
