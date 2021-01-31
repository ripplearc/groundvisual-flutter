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
  final Stream<Tuple2<int, int>> highlightRodBarStream;

  DailyWorkingTimeDataLoaded(
      this.chartData, this.siteName, this.date, this.highlightRodBarStream);

  @override
  List<Object> get props => [chartData, siteName, date];
}

class DailyWorkingTimeBarRodHighlighted extends DailyWorkingTimeState {
  final int groupId;
  final int rodId;

  final WorkingTimeChartData chartData;
  final String siteName;
  final DateTime date;

  DailyWorkingTimeBarRodHighlighted(
      this.groupId, this.rodId, this.chartData, this.siteName, this.date);

  @override
  List<Object> get props => [groupId, rodId, chartData, siteName, date];
}

/// Indicate the thumbnail image loading is in progress.
class SiteSnapShotLoading extends DailyWorkingTimeState {}

/// Hide the thumbnail image.
class SiteSnapShotHiding extends DailyWorkingTimeState {}

/// Showing thumbnail image corresponding to the selected rod bar.
class SiteSnapShotThumbnailLoaded extends DailyWorkingTimeState {
  final int groupId;
  final int rodId;
  final String assetName;

  SiteSnapShotThumbnailLoaded(this.groupId, this.rodId, this.assetName);

  @override
  List<Object> get props => [this.groupId, this.rodId, this.assetName];
}
