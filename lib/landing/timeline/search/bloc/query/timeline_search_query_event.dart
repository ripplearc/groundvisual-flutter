part of 'timeline_search_query_bloc.dart';

@immutable
abstract class TimelineSearchQueryEvent extends Equatable {}

class BuildInitialTimelineSearchQuery extends TimelineSearchQueryEvent {
  final DateTime startDate;
  final DateTime endDate;

  BuildInitialTimelineSearchQuery(this.startDate, this.endDate);

  @override
  List<Object?> get props => [];
}
