part of 'working_time_chart_touch_bloc.dart';

/// State that reflects the image corresponding to the touched rod bar.
@immutable
abstract class SiteSnapShotState extends Equatable {
  @override
  List<Object> get props => [];
}

class WorkingTimeChartTouchInitial extends SiteSnapShotState {
  final CameraPosition cameraPosition;

  WorkingTimeChartTouchInitial(
      {this.cameraPosition = const CameraPosition(
          target: LatLng(44.182205, -84.506836), zoom: 10)});
}

class SiteSnapShotThumbnail extends SiteSnapShotState {
  final int groupId;
  final int rodId;
  final String assetName;

  SiteSnapShotThumbnail(this.groupId, this.rodId, this.assetName);

  @override
  List<Object> get props => [this.groupId, this.rodId, this.assetName];
}

class SiteSnapShotWorkArea extends SiteSnapShotState {
  final Set<Polygon> workAreas;
  final CameraPosition cameraPosition;

  SiteSnapShotWorkArea(this.workAreas, this.cameraPosition);

  @override
  List<Object> get props => [this.workAreas, this.cameraPosition];
}
