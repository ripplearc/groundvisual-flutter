import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/map/map_helper.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:groundvisual_flutter/repositories/site_workzone_repository.dart';
import 'package:injectable/injectable.dart';

/// WorkingZoneMapViewModel finds the work areas given the site and time.
@injectable
class WorkZoneMapViewModel {
  final SiteWorkZoneRepository siteWorkZoneRepository;
  final Cartographer cartographer;

  WorkZoneMapViewModel(this.siteWorkZoneRepository, this.cartographer);

  Future<CameraPosition> getCameraPositionAtTime(
      String siteName, DateTime time) async {
    List<dynamic> result = await Future.wait<dynamic>([
      _getCameraLatLngAtTime(siteName, time),
      _getCameraZoomAtTime(siteName, time)
    ]);
    return CameraPosition(target: result[0], zoom: result[1], tilt: 30);
  }

  Future<CameraPosition> getCameraPositionAtDate(
      String siteName, DateTime time) async {
    List<dynamic> result = await Future.wait<dynamic>([
      _getCameraLatLngAtDate(siteName, time),
      _getCameraZoomAtDate(siteName, time)
    ]);
    return CameraPosition(target: result[0], zoom: result[1], tilt: 30);
  }

  Future<LatLng> _getCameraLatLngAtTime(String siteName, DateTime time) =>
      siteWorkZoneRepository
          .getWorkZoneAtTime(siteName, time)
          .then((zone) => _calcCameraLatLng(zone));

  Future<LatLng> _getCameraLatLngAtDate(String siteName, DateTime time) =>
      siteWorkZoneRepository
          .getWorkZoneAtDate(siteName, time)
          .then((zone) => _calcCameraLatLng(zone));

  LatLng _calcCameraLatLng(ConstructionZone zone) => cartographer
      .calcCentroid(zone.regions.expand((e) => e.points).toList().toRegion());

  Future<double> _getCameraZoomAtTime(String siteName, DateTime time) =>
      siteWorkZoneRepository.getWorkZoneAtTime(siteName, time).then((zone) =>
          _determineRegionZoomLevel(zone));

  Future<double> _getCameraZoomAtDate(String siteName, DateTime time) =>
      siteWorkZoneRepository.getWorkZoneAtDate(siteName, time).then((zone) =>
          _determineRegionZoomLevel(zone));

  double _determineRegionZoomLevel(ConstructionZone zone) =>
     cartographer.determineRegionZoomLevel(zone.regions
            .expand((element) => element.points)
            .toList()
            .toRegion());

  Future<Set<Polygon>> getPolygonAtTime(
          String siteName, DateTime time, BuildContext context) async =>
      siteWorkZoneRepository
          .getWorkZoneAtTime(siteName, time)
          .then((zone) => _genPolygons(context, zone));

  Future<Set<Polygon>> getPolygonAtDate(
          String siteName, DateTime time, BuildContext context) async =>
      siteWorkZoneRepository
          .getWorkZoneAtDate(siteName, time)
          .then((zone) => _genPolygons(context, zone));

  Set<Polygon> _genPolygons(BuildContext context, ConstructionZone zone) =>
      zone.regions
          .asMap()
          .map((index, region) => MapEntry(
              index,
              Polygon(
                polygonId: PolygonId(index.toString()),
                consumeTapEvents: true,
                strokeColor: Theme.of(context).colorScheme.secondary,
                strokeWidth: 2,
                fillColor: Theme.of(context).colorScheme.primary,
                points: region.points,
              )))
          .values
          .toSet();
}
