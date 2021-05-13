part of 'timeline_search_bloc.dart';

/// Event of displaying the  timelapse photos in a day on the timelapse detail page
@immutable
abstract class TimelineSearchEvent extends Equatable {}

/// Searching for the timelapse photos in a day
class SearchDailyTimeline extends TimelineSearchEvent {
  final String siteName;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String>? muids;
  final ConstructionZone? zone;

  SearchDailyTimeline(this.siteName, this.date,
      {this.muids, this.zone, this.startTime, this.endTime});

  @override
  List<Object> get props =>
      [siteName, date, muids ?? [], zone ?? ConstructionZone([])];
}

/// Tap on a timestamp cell
class TapImageAndNavigateToGallery extends TimelineSearchEvent {
  final int index;
  final BuildContext context;

  TapImageAndNavigateToGallery(this.index, this.context);

  @override
  List<Object> get props => [index];
}
