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

  DailyWorkingTimeDataLoaded copyWith(
      {WorkingTimeChartData chartDataParam,
      String siteNameParam,
      DateTime dateParam,
      Stream<Tuple2<int, int>> highlightRodBarStreamParam}) =>
     DailyWorkingTimeDataLoaded(
        chartDataParam ?? chartData,
        siteNameParam ?? siteName,
        dateParam ?? date,
        highlightRodBarStreamParam ?? highlightRodBarStream);

  @override
  List<Object> get props => [chartData, siteName, date];
}

class DailyWorkingTimeBarRodHighlighted extends DailyWorkingTimeState {
  final int _groupId;
  final int _rodId;

  final String siteName;
  final DateTime time;
  final BuildContext context;

  DailyWorkingTimeBarRodHighlighted(
      this._groupId, this._rodId, this.siteName, this.time, this.context);

  bool get unselected => _groupId == -1 && _rodId == -1;

  @override
  List<Object> get props => [_groupId, _rodId, siteName, time];
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
