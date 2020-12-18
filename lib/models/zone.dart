import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

/// A list of LatLng that forms a convel hull to represent a work area.
class Region {
  final List<LatLng> points;

  Region(this.points);
}

@injectable
class ConstructionZone {
  final List<Region> regions;

  ConstructionZone(this.regions);
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
