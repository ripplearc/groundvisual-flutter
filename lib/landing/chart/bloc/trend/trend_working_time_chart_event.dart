part of 'trend_working_time_chart_bloc.dart';

abstract class TrendWorkingTimeChartEvent extends Equatable {
  const TrendWorkingTimeChartEvent();
}

/// Load the trend working time chart and start searching for working time data.
class SearchWorkingTimeOnTrend extends TrendWorkingTimeChartEvent {
  final String siteName;
  final TrendPeriod period;

  SearchWorkingTimeOnTrend(this.siteName, this.period);

  @override
  List<Object> get props => [siteName, period];
}

/// Select a bar rod on the trend chart with group and rod information.
/// It includes site, date range and period information to make it easy to search.
class SelectTrendChartBarRod extends TrendWorkingTimeChartEvent {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTimeRange range;
  final TrendPeriod period;

  final BuildContext context;
  static const int UnSelectedGroupId = -1;
  static const int UnSelectedRodId = -1;

  SelectTrendChartBarRod(this.siteName, this.range, this.period, this.context,
      this.groupId, this.rodId);

  @override
  List<Object> get props => [groupId, rodId, siteName, range, period];
}
