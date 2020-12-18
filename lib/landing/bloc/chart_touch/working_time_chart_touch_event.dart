part of 'working_time_chart_touch_bloc.dart';

/// Event of user touching on a certain bar rod.
@immutable
abstract class WorkingTimeChartTouchEvent extends Equatable {
  const WorkingTimeChartTouchEvent();
}

class NoBarRodSelection extends WorkingTimeChartTouchEvent {
  final String siteName;
  final DateTime date;

  NoBarRodSelection(this.siteName, this.date);

  @override
  List<Object> get props => [];
}

class BarRodSelection extends WorkingTimeChartTouchEvent {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTime date;

  final BuildContext context;

  BarRodSelection(
      this.groupId, this.rodId, this.siteName, this.date, this.context);

  @override
  List<Object> get props => [groupId, rodId];
}
