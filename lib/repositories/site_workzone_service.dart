import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/models/site_work_records.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';

/// Network service to get the work zone for a specific time, date or over a period.
abstract class SiteWorkZoneService {
  /// Get the work zone at a specific time duration.
  Future<ConstructionZone> getWorkZoneAtTime(
      String siteName, DateTime startTime, DateTime endTime);

  /// Get the work zone for a day.
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time);

  /// Get the work zone for a period.
  Future<ConstructionZone> getWorkZoneAtPeriod(
      String siteName, DateTime time, TrendPeriod period);
}

@Injectable(as: SiteWorkZoneService)
class SiteWorkZoneServiceImpl extends SiteWorkZoneService {
  @override
  Future<ConstructionZone> getWorkZoneAtDate(String siteName, DateTime time) =>
      rootBundle
          .loadString(_getDailyWorkZoneAsset(siteName))
          .then((value) => json.decode(value))
          .then((decoded) => SiteConstructionZone.fromJson(decoded)
              .records
              .firstWhere((element) => time.weekday == element.date.weekday,
                  orElse: (() => UnitConstructionZone(Date.startOfToday, 900,
                      ConstructionZone(<Region>[].toList()))))
              .zone);

  String _getDailyWorkZoneAsset(String siteName) =>
      {
        'Penton Rise': 'assets/mock_response/penton_date_work_zone.json',
        'M51': 'assets/mock_response/m51_date_work_zone.json',
        'Kensington': 'assets/mock_response/kensington_date_work_zone.json',
        'Cresent Blvd': 'assets/mock_response/cresent_date_work_zone.json'
      }[siteName] ??
      'assets/mock_response/penton_date_work_zone.json';

  @override
  Future<ConstructionZone> getWorkZoneAtTime(
          String siteName, DateTime startTime, DateTime endTime) =>
      rootBundle
          .loadString('assets/mock_response/penton_time_work_zone.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteConstructionZone.fromJson(decoded)
              .records
              .firstWhere((element) => startTime.minute == element.date.minute,
                  orElse: (() => UnitConstructionZone(Date.startOfToday, 900,
                      ConstructionZone(<Region>[].toList()))))
              .zone);

  @override
  Future<ConstructionZone> getWorkZoneAtPeriod(
          String siteName, DateTime time, TrendPeriod period) =>
      rootBundle
          .loadString('assets/mock_response/penton_period_work_zone.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteConstructionZone.fromJson(decoded)
              .records
              .firstWhere(
                  (element) => period.seconds() == element.durationInSeconds,
                  orElse: (() => UnitConstructionZone(Date.startOfToday, 900,
                      ConstructionZone(<Region>[].toList()))))
              .zone);
}
