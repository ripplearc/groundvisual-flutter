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

  DailyWorkingTimeDataLoaded(this.chartData, this.siteName, this.date);

  @override
  List<Object> get props => [chartData, siteName, date];
}

class SiteSnapShotLoading extends DailyWorkingTimeState {
  @override
  List<Object> get props => [];
}

/// Showing thumbnail image corresponding to the selected rod bar.
class SiteSnapShotThumbnailLoaded extends DailyWorkingTimeState {
  final int groupId;
  final int rodId;
  final String assetName;

  SiteSnapShotThumbnailLoaded(this.groupId, this.rodId, this.assetName);

  @override
  List<Object> get props => [this.groupId, this.rodId, this.assetName];
}
