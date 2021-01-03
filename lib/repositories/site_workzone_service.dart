import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/models/site_work_records.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_date/dart_date.dart';

/// Network service to get the work zone for a specific time or over time.
abstract class SiteWorkZoneService {
  /// Get the work zone at a specific time.
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time);

  /// Get the work zone for a day.
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time);
}

@Injectable(as: SiteWorkZoneService)
class SiteWorkZoneServiceImpl extends SiteWorkZoneService {
  @override
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time) =>
      rootBundle
          .loadString('assets/mock_response/penton_date_work_zone.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteConstructionZone.fromJson(decoded)
              .records
              .firstWhere((element) => time.weekday == element.date.weekday,
                  orElse: (() => UnitConstructionZone(
                      Date.startOfToday, 900, ConstructionZone([].toList()))))
              .zone);

  @override
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time) =>
      rootBundle
          .loadString('assets/mock_response/penton_time_work_zone.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteConstructionZone.fromJson(decoded)
              .records
              .firstWhere((element) => time.minute == element.date.minute,
                  orElse: (() => UnitConstructionZone(
                      Date.startOfToday, 900, ConstructionZone([].toList()))))
              .zone);
}
