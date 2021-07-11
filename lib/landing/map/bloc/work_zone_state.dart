part of 'work_zone_bloc.dart';

@immutable
abstract class WorkZoneState extends Equatable {
  final String? siteName;
  final Set<Polygon> workZone;
  final CameraPosition cameraPosition;

  WorkZoneState(this.siteName, this.workZone, this.cameraPosition);
}

/// Display the map with a default location and zoom level.
class WorkZoneInitial extends WorkZoneState {
  WorkZoneInitial()
      : super(
            null,
            {},
            const CameraPosition(
                target: LatLng(44.182205, -84.506836), zoom: 10));

  @override
  List<Object> get props => [workZone, cameraPosition];
}

/// Represent the work zone with a set of polygons from a camera position.
class WorkZonePolygons extends WorkZoneState {
  final Set<Polygon> highlightedWorkZone;
  final String siteName;

  WorkZonePolygons(this.siteName, Set<Polygon> workZone,
      this.highlightedWorkZone, CameraPosition cameraPosition)
      : super(siteName, workZone, cameraPosition);

  @override
  List<Object> get props =>
      [siteName, workZone, cameraPosition, highlightedWorkZone];

  @override
  String toString() =>
      workZone
          .map((e) => e.points
              .map((e) => "${e.latitude} ${e.longitude}")
              .reduce((value, element) => "$value $element"))
          .reduce((value, element) => "$value points 🧬: $element") +
      " \n 👠  " +
      highlightedWorkZone
          .map((e) => e.points
              .map((e) => "${e.latitude} ${e.longitude}")
              .reduce((value, element) => "$value $element"))
          .reduce((value, element) => "$value points 🧬: $element") +
      " \n 📸 " +
      cameraPosition.toString();
}
