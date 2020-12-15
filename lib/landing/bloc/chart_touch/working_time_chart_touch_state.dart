part of 'working_time_chart_touch_bloc.dart';

/// State that reflects the image corresponding to the touched rod bar.
@immutable
abstract class WorkingTimeChartTouchState extends Equatable {
  @override
  List<Object> get props => [];
}

class WorkingTimeChartTouchInitial extends WorkingTimeChartTouchState {

  final CameraPosition cameraPosition;

  WorkingTimeChartTouchInitial(this.cameraPosition);
}

class WorkingTimeChartTouchShowThumbnail extends WorkingTimeChartTouchState {
  final int groupId;
  final int rodId;
  final String assetName;

  WorkingTimeChartTouchShowThumbnail(this.groupId, this.rodId, this.assetName);

  @override
  List<Object> get props => [this.groupId, this.rodId, this.assetName];
}

class WorkingTimeChartTouchShowWorkArea extends WorkingTimeChartTouchState {
  final Set<Polygon> workAreas;
  final CameraPosition cameraPosition;

  WorkingTimeChartTouchShowWorkArea(this.workAreas, this.cameraPosition);

  @override
  List<Object> get props => [this.workAreas];
}
