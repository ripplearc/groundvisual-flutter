part of 'working_time_chart_touch_bloc.dart';

@immutable
abstract class WorkingTimeChartTouchEvent extends Equatable {
  const WorkingTimeChartTouchEvent();
}

class NoBarRodSelection extends WorkingTimeChartTouchEvent {
  @override
  List<Object> get props => [];
}

class BarRodSelection extends WorkingTimeChartTouchEvent {
  final int groupId;
  final int rodId;

  BarRodSelection(this.groupId, this.rodId);

  @override
  List<Object> get props => [groupId, rodId];
}
