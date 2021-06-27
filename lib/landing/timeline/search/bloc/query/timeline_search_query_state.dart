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

  bool get timeRangeEdited;

  String get siteName;

  Map<MachineDetail, bool> get filteredMachines;

  String? get filterIndicator => null;

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

  @override
  bool get timeRangeEdited => false;
}

class TimelineSearchQueryUpdate extends TimelineSearchQueryState {
  final DateTimeRange dateTimeRange;
  final Map<MachineDetail, bool> filteredMachines;
  final String siteName;
  final bool timeRangeEdited;
  static const String EditTime = "Edit Time";

  TimelineSearchQueryUpdate(this.dateTimeRange, this.filteredMachines,
      this.siteName, this.timeRangeEdited);

  @override
  String get timeString =>
      dateTimeRange.start.isSameDay(dateTimeRange.end) && timeRangeEdited
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
      dateString + (timeString != EditTime ? "  |  " + timeString : "");

  @override
  String? get filterIndicator => _indicateOneIfAnyMachinesBeUnselected();

  String? _indicateOneIfAnyMachinesBeUnselected() =>
      filteredMachines.values.any((element) => !element) ? "1" : null;
}
