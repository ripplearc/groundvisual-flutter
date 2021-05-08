part of 'daily_working_time_chart_bloc.dart';

/// State that reflects the loading status of the daily working time.
/// and the image corresponding to the touched rod bar.
@immutable
abstract class DailyWorkingTimeState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Indicating the loading in progress of the daily working time.
class DailyWorkingTimeDataLoading extends DailyWorkingTimeState {}


/// Finish loading the daily working time data.
class DailyWorkingTimeDataLoaded extends DailyWorkingTimeState {
  final WorkingTimeChartData chartData;
  final String siteName;
  final DateTime date;
  final Stream<HighlightedBar> highlightRodBarStream;

  DailyWorkingTimeDataLoaded(
      this.chartData, this.siteName, this.date, this.highlightRodBarStream);

  DailyWorkingTimeDataLoaded copyWith(
          {WorkingTimeChartData? chartDataParam,
          String? siteNameParam,
          DateTime? dateParam,
          Stream<HighlightedBar>? highlightRodBarStreamParam}) =>
      DailyWorkingTimeDataLoaded(
          chartDataParam ?? chartData,
          siteNameParam ?? siteName,
          dateParam ?? date,
          highlightRodBarStreamParam ?? highlightRodBarStream);

  DailyWorkingTimeDataLoaded transformBarRod(BarRodTransform transformer) =>
      copyWith(
          chartDataParam: chartData.copyWith(
              barsParam: chartData.bars.mapBarRod(transformer)));

  DailyWorkingTimeDataLoaded transformBarGroup(BarGroupTransform transformer) =>
      copyWith(
          chartDataParam: chartData.copyWith(
              barsParam: chartData.bars.mapBarGroup(transformer)));

  @override
  List<Object> get props => [chartData, siteName, date];
}
