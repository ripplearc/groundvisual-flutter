part of 'working_time_chart_touch_bloc.dart';

/// State that reflects the image corresponding to the touched rod bar.
@immutable
abstract class DailyWorkingTimeState extends Equatable {
  @override
  List<Object> get props => [];
}

class WorkingTimeChartLoading extends DailyWorkingTimeState {}

class WorkingTimeBarChartDataLoaded extends DailyWorkingTimeState {
  final WorkingTimeChartData chartData;
  final String siteName;
  final DateTime date;

  WorkingTimeBarChartDataLoaded(this.chartData, this.siteName, this.date);

  @override
  List<Object> get props => [chartData, siteName, date];
}

class SiteSnapShotThumbnail extends DailyWorkingTimeState {
  final int groupId;
  final int rodId;
  final String assetName;

  SiteSnapShotThumbnail(this.groupId, this.rodId, this.assetName);

  @override
  List<Object> get props => [this.groupId, this.rodId, this.assetName];
}
