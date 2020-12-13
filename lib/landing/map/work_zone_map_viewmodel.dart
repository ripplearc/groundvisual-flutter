import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

/// WorkingZoneMapViewModel finds the work areas given the site and time.
@injectable
class WorkZoneMapViewModel {
  Set<Polygon> getOddPolygons(BuildContext context) {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.626985, -82.982993));
    points.add(_createLatLng(42.627034, -82.982821));
    points.add(_createLatLng(42.62702, -82.982671));
    points.add(_createLatLng(42.626939, -82.982585));
    points.add(_createLatLng(42.626835, -82.982609));
    return _genPolygons(context, points);
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Set<Polygon> getEvenPolygons(BuildContext context) {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.626584, -82.982633));
    points.add(_createLatLng(42.626669, -82.982341));
    points.add(_createLatLng(42.62659, -82.982024));
    points.add(_createLatLng(42.626436, -82.982024));
    points.add(_createLatLng(42.62641, -82.982311));
    return _genPolygons(context, points);
  }

  Set<Polygon> _genPolygons(BuildContext context, List<LatLng> points) {
    return {
      Polygon(
        polygonId: PolygonId("Test_1"),
        consumeTapEvents: true,
        strokeColor: Theme.of(context).colorScheme.secondary,
        strokeWidth: 2,
        fillColor: Theme.of(context).colorScheme.primary,
        points: points,
      )
    };
  }
}
