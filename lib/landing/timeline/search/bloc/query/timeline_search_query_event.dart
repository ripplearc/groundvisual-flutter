part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryEvent extends Equatable {}

class UpdateTimelineSearchQueryOfDateTimeRange extends TimelineSearchQueryEvent {
  final DateTimeRange range;

  UpdateTimelineSearchQueryOfDateTimeRange(this.range);

  @override
  List<Object?> get props => [range];
}
