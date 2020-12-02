part of 'working_time_chart_touch_bloc.dart';

@immutable
abstract class WorkingTimeChartTouchState extends Equatable {
  @override
  List<Object> get props => [];
}

class WorkingTimeChartTouchInitial extends WorkingTimeChartTouchState {}

class WokringTimeChartTouchShowThumbnail extends WorkingTimeChartTouchState {
  final int groupId;
  final int rodId;

  WokringTimeChartTouchShowThumbnail(this.groupId, this.rodId);

  @override
  List<Object> get props => [this.groupId, this.rodId];
}
