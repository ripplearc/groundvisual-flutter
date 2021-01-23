part of 'work_zone_map_bloc.dart';

@immutable
abstract class WorkZoneMapState extends Equatable {}

/// Display the map with a default location and zoom level.
class WorkZoneMapInitial extends WorkZoneMapState {
  final CameraPosition cameraPosition;

  WorkZoneMapInitial(
      {this.cameraPosition = const CameraPosition(
          target: LatLng(44.182205, -84.506836), zoom: 10)});

  @override
  List<Object> get props => [cameraPosition];
}

/// Represent the work zone with a set of polygons from a camera position.
class WorkZoneMapPolygons extends WorkZoneMapState {
  final Set<Polygon> workZone;
  final CameraPosition cameraPosition;

  WorkZoneMapPolygons(this.workZone, this.cameraPosition);

  @override
  List<Object> get props => [this.workZone, this.cameraPosition];
}
