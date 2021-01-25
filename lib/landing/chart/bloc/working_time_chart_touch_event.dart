part of 'working_time_chart_touch_bloc.dart';

/// Event of user touching on a certain bar rod.
@immutable
abstract class DailyWorkingTimeChartEvent extends Equatable {
  const DailyWorkingTimeChartEvent();
}

class SearchWorkingTimeOnDate extends DailyWorkingTimeChartEvent {
  final String siteName;
  final DateTime date;
  final BuildContext context;

  SearchWorkingTimeOnDate(this.siteName, this.date, this.context);

  @override
  List<Object> get props => [siteName, date];
}

class DailyChartBarRodSelection extends DailyWorkingTimeChartEvent {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTime date;

  final BuildContext context;

  DailyChartBarRodSelection(
      this.groupId, this.rodId, this.siteName, this.date, this.context);

  @override
  List<Object> get props => [groupId, rodId];
}

class TrendChartBarRodSelection extends DailyWorkingTimeChartEvent {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTimeRange range;
  final TrendPeriod period;

  final BuildContext context;

  TrendChartBarRodSelection(this.groupId, this.rodId, this.siteName, this.range,
      this.period, this.context);

  @override
  List<Object> get props => [groupId, rodId];
}
