part of 'daily_timeline_bloc.dart';

/// Event of displaying the timelapse photos in a day
abstract class DailyTimelineEvent extends Equatable {
  const DailyTimelineEvent();
}

/// Searching for the timelapse photos in a day
class SearchDailyTimelineOnDate extends DailyTimelineEvent {
  final String siteName;
  final DateTime date;

  SearchDailyTimelineOnDate(this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date];
}

/// Tap on a timestamp cell
class TapDailyTimelineCell extends DailyTimelineEvent {
  final DateTime startTime;
  final BuildContext context;

  TapDailyTimelineCell(this.startTime, this.context);

  @override
  List<Object> get props => [startTime];
}
