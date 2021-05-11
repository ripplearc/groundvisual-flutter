part of 'daily_timeline_detail_bloc.dart';

/// Event of displaying the  timelapse photos in a day on the timelapse detail page
@immutable
abstract class TimelineSearchEvent extends Equatable {}

/// Searching for the timelapse photos in a day
class SearchDailyTimeline extends TimelineSearchEvent {
  final String siteName;
  final DateTime date;
  final List<String>? muids;
  final ConstructionZone? zone;

  SearchDailyTimeline(this.siteName, this.date, {this.muids, this.zone});

  @override
  List<Object> get props =>
      [siteName, date, muids ?? [], zone ?? ConstructionZone([])];
}
