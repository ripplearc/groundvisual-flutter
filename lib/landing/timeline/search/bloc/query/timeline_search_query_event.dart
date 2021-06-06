part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryEvent extends Equatable {}

class UpdateTimelineSearchQueryOfDateRange extends TimelineSearchQueryEvent {
  final DateTimeRange range;

  UpdateTimelineSearchQueryOfDateRange(this.range);

  @override
  List<Object?> get props => [range];
}
