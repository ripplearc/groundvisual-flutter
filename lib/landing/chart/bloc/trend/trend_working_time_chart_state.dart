part of 'trend_working_time_chart_bloc.dart';


/// State that reflects the loading of the trend working time.
abstract class TrendWorkingTimeChartState extends Equatable {
  const TrendWorkingTimeChartState();
}

/// Indicating the loading in progress of the trend working time.
class TrendWorkingTimeDataLoading extends TrendWorkingTimeChartState {
  final TrendPeriod period;

  TrendWorkingTimeDataLoading(this.period);

  @override
  List<Object> get props => [period];
}

/// Finish loading the trend working time data.
class TrendWorkingTimeDataLoaded extends TrendWorkingTimeChartState {
  final WorkingTimeChartData chartData;
  final String siteName;
  final TrendPeriod period;
  final DateTimeRange dateRange;

  TrendWorkingTimeDataLoaded(
      this.chartData, this.siteName, this.period, this.dateRange);

  TrendWorkingTimeDataLoaded copyWith({
    WorkingTimeChartData chartDataParam,
    String siteNameParam,
    TrendPeriod periodParam,
    DateTimeRange dateRangeParam,
  }) =>
      TrendWorkingTimeDataLoaded(
          chartDataParam ?? chartData,
          siteNameParam ?? siteName,
          periodParam ?? period,
          dateRangeParam ?? dateRange);

  TrendWorkingTimeDataLoaded transformBarChart(BarRodTransform transform) =>
      copyWith(
          chartDataParam: chartData.copyWith(
              barsParam: chartData.bars.mapBarRod(transform)));

  TrendWorkingTimeDataLoaded transformBarGroup(BarGroupTransform transformer) =>
      copyWith(
          chartDataParam: chartData.copyWith(
              barsParam: chartData.bars.mapBarGroup(transformer)));
  @override
  List<Object> get props => [chartData, siteName, period, dateRange];
}

/// Select a date in the trend chart
class TrendWorkingTimeBarRodHighlighted extends TrendWorkingTimeChartState {
  final String siteName;
  final DateTime time;

  TrendWorkingTimeBarRodHighlighted(this.siteName, this.time);

  @override
  List<Object> get props => [siteName, time];
}
