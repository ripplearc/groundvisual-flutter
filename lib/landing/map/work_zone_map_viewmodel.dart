import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

/// WorkingZoneMapViewModel finds the work areas given the site and time.
@injectable
class WorkZoneMapViewModel {
  Future<CameraPosition> getCameraPosition(String siteName) => Future.delayed(
      Duration(seconds: 1),
      () => CameraPosition(target: LatLng(42.626985, -82.982993), zoom: 16.4, tilt: 30));

  Future<CameraPosition> getPentonCameraPosition(String siteName) =>
      Future.delayed(
          Duration(seconds: 1),
          () => CameraPosition(
              target: LatLng(42.456140, -83.455860), zoom: 16.4, tilt: 30));

  Future<Set<Polygon>> getOddPolygons(BuildContext context) async {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(42.626985, -82.982993));
    points.add(_createLatLng(42.627034, -82.982821));
    points.add(_createLatLng(42.62702, -82.982671));
    points.add(_createLatLng(42.626939, -82.982585));
    points.add(_createLatLng(42.626835, -82.982609));

    return Future.delayed(
        Duration(seconds: 1), () => _genPolygons(context, points));
  }

  Future<Set<Polygon>> getEvenPolygons(BuildContext context) {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.626584, -82.982633));
    points.add(_createLatLng(42.626669, -82.982341));
    points.add(_createLatLng(42.62659, -82.982024));
    points.add(_createLatLng(42.626436, -82.982024));
    points.add(_createLatLng(42.62641, -82.982311));
    return Future.value(_genPolygons(context, points));
  }

  Future<Set<Polygon>> getPentonPolygons(BuildContext context) {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.456211, -83.455702));
    points.add(_createLatLng(42.456286, -83.455401));
    points.add(_createLatLng(42.456060, -83.455127));
    points.add(_createLatLng(42.455890, -83.455315));
    points.add(_createLatLng(42.455906, -83.455836));
    return Future.value(_genPolygons(context, points));
  }

//
// final test = await rootBundle.loadString('assets/mock_response/test.json');
// final decoded = json.decode(test);
// final object = SiteWorkZone.fromJson(decoded);
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
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
