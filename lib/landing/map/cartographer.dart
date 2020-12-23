import 'dart:math' show cos, sqrt, asin, pi, min, max, log, ln2;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';

/// Helper class to compute the zoom level and focus.
@injectable
class Cartographer {
  LatLng calcCentroid(Region region) => LatLng(
      region.points.fold(0, (prev, point) => prev + point.latitude) /
          region.points.length,
      region.points.fold(0, (prev, point) => prev + point.longitude) /
          region.points.length);

  double get minZoomLevel => 20;

  double get maxZoomLevel => 1;

  double calculateDistanceInMeter(LatLng pointA, LatLng pointB) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((pointB.latitude - pointA.latitude) * p) / 2 +
        c(pointA.latitude * p) *
            c(pointB.latitude * p) *
            (1 - c((pointB.longitude - pointA.longitude) * p)) /
            2;
    return 12742 * 1000 * asin(sqrt(a));
  }

  double calcDiameterInMeter(List<LatLng> points) {
    double circumference = 0;
    if (points.length <= 1) return circumference;
    for (var i = 0; i < points.length - 1; i++) {
      circumference += calculateDistanceInMeter(points[i], points[i + 1]);
    }
    return circumference / pi;
  }

  double calcZoomLevel(double distance) =>
      min(minZoomLevel, max(maxZoomLevel, log(591657550 / distance) / ln2 - 7));

  double determineRegionZoomLevel(Region region) =>
      calcZoomLevel(calcDiameterInMeter(region.points));

  double determineZoneZoomLevel(ConstructionZone zone) {
    if (zone.regions.isEmpty) {
      return maxZoomLevel;
    } else if (zone.regions.length == 1) {
      return determineRegionZoomLevel(zone.regions.first);
    } else {
      return determineRegionZoomLevel(zone.regions
          .map((region) => calcCentroid(region))
          .toList()
          .toRegion());
    }
  }
}
