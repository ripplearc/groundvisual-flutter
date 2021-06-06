part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryState extends Equatable {
  DateTimeRange get dateRange;

  String get dateString => dateRange.start.toStartEndDateString(dateRange.end);

  String get timeString;

  bool get enableTimeEdit => dateRange.start.isSameDay(dateRange.end);

  String get siteName;

  Map<String, bool> get filteredMachines;

  List<Object?> get props => [dateRange, siteName, filteredMachines];
}

class TimelineSearchQueryInitial extends TimelineSearchQueryState {
  final DateTimeRange dateRange;
  final Map<String, bool> filteredMachines;
  final String siteName;

  TimelineSearchQueryInitial(
      this.dateRange, this.siteName, this.filteredMachines);

  @override
  String get timeString => "Edit Time";
}

class TimelineSearchQueryUpdate extends TimelineSearchQueryState {
  final DateTimeRange dateRange;
  final Map<String, bool> filteredMachines;
  final String siteName;

  TimelineSearchQueryUpdate(
      this.dateRange, this.filteredMachines, this.siteName);

  @override
  String get timeString => "Edit Time";
}
