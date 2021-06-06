part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryState extends Equatable {
  String get dateString;
}

class TimelineSearchQueryInitial extends TimelineSearchQueryState {
  final DateTime startDate;
  final DateTime endDate;

  // final DateTime? startTime;
  // final DateTime? endTime;
  // final List<String> availableMachines;
  // final List<String> selectedMachines;

  TimelineSearchQueryInitial(this.startDate, this.endDate);

  @override
  List<Object?> get props => [];

  @override
  String get dateString => startDate.toStartEndDateString(endDate);
}
