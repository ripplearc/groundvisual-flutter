import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/models/site_work_records.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_date/dart_date.dart';

abstract class SiteWorkZoneService {
  Future<ConstructionZone> getWorkZoneAtTime(String siteName, DateTime time);

  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time);
}

@Injectable(as: SiteWorkZoneService)
class SiteWorkZoneServiceImpl extends SiteWorkZoneService {
  @override
  Future<ConstructionZone> getWorkZoneAtDate(
      String siteName, DateTime time) async {
    final test = await rootBundle
        .loadString('assets/mock_response/penton_date_work_zone.json');
    final decoded = json.decode(test);
    return SiteConstructionZone.fromJson(decoded)
        .records
        .firstWhere((element) => time.weekday == element.date.weekday,
        orElse: (() => UnitConstructionZone(
            Date.startOfToday, 900, ConstructionZone([].toList()))))
        .zone;
  }

  @override
  Future<ConstructionZone> getWorkZoneAtTime(
      String siteName, DateTime time) async {
    final test = await rootBundle
        .loadString('assets/mock_response/penton_time_work_zone.json');
    final decoded = json.decode(test);

    return SiteConstructionZone.fromJson(decoded)
        .records
        .firstWhere((element) => time.minute == element.date.minute,
            orElse: (() => UnitConstructionZone(
                Date.startOfToday, 900, ConstructionZone([].toList()))))
        .zone;
  }
}
