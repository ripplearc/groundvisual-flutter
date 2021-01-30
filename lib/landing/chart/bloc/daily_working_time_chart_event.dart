part of 'daily_working_time_chart_bloc.dart';

/// Event of user touching on a certain bar rod.
@immutable
abstract class DailyWorkingTimeChartEvent extends Equatable {
  const DailyWorkingTimeChartEvent();
}

/// Load the daily working time chart and start searching for working time data.
class SearchWorkingTimeOnDate extends DailyWorkingTimeChartEvent {
  final String siteName;
  final DateTime date;
  final BuildContext context;

  SearchWorkingTimeOnDate(this.siteName, this.date, this.context);

  @override
  List<Object> get props => [siteName, date];
}

/// Select a bar rod on the daily chart with group and rod information.
/// It includes site, and date information to make it easy to search.
class SelectDailyChartBarRod extends DailyWorkingTimeChartEvent {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTime date;
  final bool showThumbnail;

  final BuildContext context;

  SelectDailyChartBarRod(
      this.groupId, this.rodId, this.siteName, this.date, this.context,
      {this.showThumbnail = true});

  @override
  List<Object> get props => [groupId, rodId];
}
