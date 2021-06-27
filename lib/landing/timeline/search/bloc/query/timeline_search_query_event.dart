part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryEvent extends Equatable {}

class UpdateTimelineSearchQueryFilter extends TimelineSearchQueryEvent {
  @override
  List<Object?> get props => [];
}

class UpdateTimelineSearchQueryOfDateRange extends TimelineSearchQueryEvent {
  final DateTimeRange range;

  UpdateTimelineSearchQueryOfDateRange(this.range);

  @override
  List<Object?> get props => [range];
}

class UpdateTimelineSearchQueryOfTimeRange extends TimelineSearchQueryEvent {
  final DateTimeRange range;

  UpdateTimelineSearchQueryOfTimeRange(this.range);

  @override
  List<Object?> get props => [range];
}

class UpdateTimelineSearchQueryOfSelectedMachines
    extends TimelineSearchQueryEvent {
  final Map<MachineDetail, bool> filteredMachines;

  UpdateTimelineSearchQueryOfSelectedMachines(this.filteredMachines);

  @override
  List<Object?> get props => [filteredMachines];
}
