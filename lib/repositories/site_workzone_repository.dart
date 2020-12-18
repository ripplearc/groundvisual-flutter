import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';

abstract class SiteWorkZoneRepository {
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time);

  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time);
}

@Singleton(as: SiteWorkZoneRepository)
class SiteWorkZoneRepositoryImpl extends SiteWorkZoneRepository {
  @factoryMethod
  static Future<SiteWorkZoneRepositoryImpl> create() async {
    return SiteWorkZoneRepositoryImpl();
  }

  @override
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time) {
    return {
      "M51": _getM51Zone,
      "Cresent Blvd": _getCresentZone,
      "Kensington": _getKensingtonZone,
      "Penton Rise": _getPentonZone
    }[siteName];
  }

  @override
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time) {
    return {
      "M51": _getM51Zone,
      "Cresent Blvd": _getCresentZone,
      "Kensington": _getKensingtonZone,
      "Penton Rise": _getPentonZone
    }[siteName];
  }

  Future<ConstructionZone> get _getM51Zone async => Future.value([
        [
          _createLatLng(42.626985, -82.982993),
          _createLatLng(42.627034, -82.982821),
          _createLatLng(42.62702, -82.982671),
          _createLatLng(42.626939, -82.982585),
          _createLatLng(42.626835, -82.982609)
        ].toList().toRegion(),
        [
          _createLatLng(42.626584, -82.982633),
          _createLatLng(42.626669, -82.982341),
          _createLatLng(42.62659, -82.982024),
          _createLatLng(42.626436, -82.982024),
          _createLatLng(42.62641, -82.982311)
        ].toList().toRegion()
      ].toList().toZone());

  Future<ConstructionZone> get _getPentonZone async => Future.value([
        [
          _createLatLng(42.456211, -83.455702),
          _createLatLng(42.456286, -83.455401),
          _createLatLng(42.456060, -83.455127),
          _createLatLng(42.455890, -83.455315),
          _createLatLng(42.455906, -83.455836)
        ].toList().toRegion(),
        [
          _createLatLng(42.454413, -83.459160),
          _createLatLng(42.454255, -83.458542),
          _createLatLng(42.453950, -83.458564),
          _createLatLng(42.453930, -83.459557),
          _createLatLng(42.454345, -83.460301)
        ].toList().toRegion()
      ].toZone());

  Future<ConstructionZone> get _getCresentZone async => Future.value(<LatLng>[
        _createLatLng(42.485215, -83.472516),
        _createLatLng(42.485116, -83.472060),
        _createLatLng(42.484998, -83.472248),
        _createLatLng(42.484970, -83.472752),
        _createLatLng(42.485180, -83.473279)
      ].toRegion().toZone());

  Future<ConstructionZone> get _getKensingtonZone async => Future.value([
        [
          _createLatLng(42.517211, -83.688453),
          _createLatLng(42.517591, -83.685812),
          _createLatLng(42.515519, -83.685275),
          _createLatLng(42.514491, -83.688045),
          _createLatLng(42.514776, -83.691008)
        ].toList().toRegion()
      ].toList().toZone());

//
// final test = await rootBundle.loadString('assets/mock_response/test.json');
// final decoded = json.decode(test);
// final object = SiteWorkZone.fromJson(decoded);
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}
