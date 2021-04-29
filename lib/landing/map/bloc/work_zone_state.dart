part of 'work_zone_bloc.dart';

@immutable
abstract class WorkZoneState extends Equatable {}

/// Display the map with a default location and zoom level.
class WorkZoneInitial extends WorkZoneState {
  final CameraPosition cameraPosition;

  WorkZoneInitial(
      {this.cameraPosition = const CameraPosition(
          target: LatLng(44.182205, -84.506836), zoom: 10)});

  @override
  List<Object> get props => [cameraPosition];
}

/// Represent the work zone with a set of polygons from a camera position.
class WorkZonePolygons extends WorkZoneState {
  final Set<Polygon> workZone;
  final CameraPosition cameraPosition;

  WorkZonePolygons(this.workZone, this.cameraPosition);

  @override
  List<Object> get props => [this.workZone, this.cameraPosition];
}
