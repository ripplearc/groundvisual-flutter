part of 'trend_working_time_chart_bloc.dart';

abstract class TrendWorkingTimeChartState extends Equatable {
  const TrendWorkingTimeChartState();
}

class TrendWorkingTimeChartInitial extends TrendWorkingTimeChartState {
  @override
  List<Object> get props => [];
}

class TrendWorkingTimeDataLoading extends TrendWorkingTimeChartState {
  final TrendPeriod period;

  TrendWorkingTimeDataLoading(this.period);

  @override
  List<Object> get props => [period];
}

class TrendWorkingTimeDataLoaded extends TrendWorkingTimeChartState {
  final WorkingTimeChartData chartData;
  final String siteName;
  final TrendPeriod period;
  final DateTimeRange dateRange;

  TrendWorkingTimeDataLoaded(
      this.chartData, this.siteName, this.period, this.dateRange);

  @override
  List<Object> get props => [chartData, siteName, period, dateRange];
}
