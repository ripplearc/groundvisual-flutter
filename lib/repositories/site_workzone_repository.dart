import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:groundvisual_flutter/repositories/site_workzone_service.dart';
import 'package:injectable/injectable.dart';

/// Repository to provide the work zone at specific time, date or over a period of time.
abstract class SiteWorkZoneRepository {
  /// Get the work zone at specific time, typically over 15 mins.
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time);

  /// Get the work zone for one day.
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time);

  /// Get the work zone for a period .
  Future<ConstructionZone> getWorkZoneAtPeriod(
      String siteName, DateTime date, TrendPeriod period);
}

@LazySingleton(as: SiteWorkZoneRepository)
class SiteWorkZoneRepositoryImpl extends SiteWorkZoneRepository {
  final SiteWorkZoneService siteWorkZoneService;

  SiteWorkZoneRepositoryImpl(this.siteWorkZoneService);

  @override
  Future<ConstructionZone> getWorkZoneAtPeriod(
          String siteName, DateTime date, TrendPeriod period) =>
      {
        "M51": _getM51Zone,
        "Cresent Blvd": _getCresentZone,
        "Kensington": _getKensingtonZoneAtDate,
        "Penton Rise":
            siteWorkZoneService.getWorkZoneAtPeriod(siteName, date, period)
      }[siteName] ??
      siteWorkZoneService.getWorkZoneAtPeriod(siteName, date, period);

  @override
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time) =>
      siteWorkZoneService.getWorkZoneAtDate(siteName, time);

  @override
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time) {
    switch (siteName) {
      case "M51":
        return _getM51Zone;
      case "Cresent Blvd":
        return _getCresentZone;
      case "Kensington":
        return _getKensingtonZoneAtTime;
      default:
        return siteWorkZoneService.getWorkZoneAtTime("Penton Rise", time);
    }
  }

  Future<ConstructionZone> get _getM51Zone async => Future.value([
        [
          LatLng(42.626985, -82.982993),
          LatLng(42.627034, -82.982821),
          LatLng(42.62702, -82.982671),
          LatLng(42.626939, -82.982585),
          LatLng(42.626835, -82.982609)
        ].toList().toRegion(),
        [
          LatLng(42.626584, -82.982633),
          LatLng(42.626669, -82.982341),
          LatLng(42.62659, -82.982024),
          LatLng(42.626436, -82.982024),
          LatLng(42.62641, -82.982311)
        ].toList().toRegion()
      ].toList().toZone());

  Future<ConstructionZone> get _getCresentZone async => Future.value(<LatLng>[
        LatLng(42.485215, -83.472516),
        LatLng(42.485116, -83.472060),
        LatLng(42.484998, -83.472248),
        LatLng(42.484970, -83.472752),
        LatLng(42.485180, -83.473279)
      ].toRegion().toZone());

  Future<ConstructionZone> get _getKensingtonZoneAtTime async => Future.value([
        [
          LatLng(42.517211, -83.688453),
          LatLng(42.517591, -83.685812),
          LatLng(42.515519, -83.685275),
          LatLng(42.514491, -83.688045),
          LatLng(42.514776, -83.691008)
        ].toList().toRegion()
      ].toList().toZone());

  Future<ConstructionZone> get _getKensingtonZoneAtDate async => Future.value([
        [
          LatLng(42.516714, -83.694909),
          LatLng(42.516398, -83.685805),
          LatLng(42.516208, -83.676872),
          LatLng(42.512475, -83.678332),
          LatLng(42.512349, -83.684774)
        ].toList().toRegion()
      ].toList().toZone());
}
