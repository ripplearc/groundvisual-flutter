import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:groundvisual_flutter/extensions/null_aware.dart';

/// A list of LatLng that forms a convex hull to represent a work area.
class Region {
  final List<LatLng> points;

  Region(this.points);

  factory Region.fromJson(List<dynamic> json) =>
      Region(json.mapNotNull((e) => LatLng.fromJson(e)).toList());

  dynamic toJson() => points.map((e) => e.toJson());
}

/// A zone composed of multiple regions.
@injectable
class ConstructionZone {
  final List<Region> regions;

  ConstructionZone(this.regions);

  factory ConstructionZone.fromJson(List<dynamic> json) =>
      ConstructionZone(json.map((e) => Region.fromJson(e)).toList());

  dynamic toJson() => regions.map((e) => e.toJson());
}

extension LatLngRegion on List<LatLng> {
  Region toRegion() {
    return Region(this);
  }
}

extension LatLngZone on List<Region> {
  ConstructionZone toZone() {
    return ConstructionZone(this);
  }
}

extension RegionZone on Region {
  ConstructionZone toZone() {
    return ConstructionZone([this].toList());
  }
}
