part of 'daily_timeline_detail_bloc.dart';

/// Event of displaying the  timelapse photos in a day on the timelapse detail page
@immutable
abstract class DailyTimelineDetailEvent extends Equatable {}

/// Searching for the timelapse photos in a day
class SearchDailyTimelineOnDate extends DailyTimelineDetailEvent {
  final String siteName;
  final DateTime date;

  SearchDailyTimelineOnDate(this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date];
}
