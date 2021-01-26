part of 'trend_working_time_chart_bloc.dart';

abstract class TrendWorkingTimeChartEvent extends Equatable {
  const TrendWorkingTimeChartEvent();
}

class SearchWorkingTimeOnTrend extends TrendWorkingTimeChartEvent {
  final String siteName;
  final TrendPeriod period;
  final BuildContext context;

  SearchWorkingTimeOnTrend(this.siteName, this.period, this.context);

  @override
  List<Object> get props => [siteName, period];
}


class TrendChartBarRodSelection extends TrendWorkingTimeChartEvent {
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
