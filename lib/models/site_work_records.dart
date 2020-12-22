import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:groundvisual_flutter/models/zone.dart';

part 'site_work_records.g.dart';

@JsonSerializable()
class SiteConstructionZone {
  final String site;
  final List<UnitConstructionZone> records;

  SiteConstructionZone(this.site, this.records);

  factory SiteConstructionZone.fromJson(Map<String, dynamic> json) =>
      _$SiteConstructionZoneFromJson(json);

  Map<String, dynamic> toJson() => _$SiteConstructionZoneToJson(this);
}

@JsonSerializable()
class UnitConstructionZone {
  final DateTime date;
  final int durationInSeconds;

  final ConstructionZone zone;

  UnitConstructionZone(this.date, this.durationInSeconds, this.zone);

  factory UnitConstructionZone.fromJson(Map<String, dynamic> json) =>
      _$UnitConstructionZoneFromJson(json);

  Map<String, dynamic> toJson() => _$UnitConstructionZoneToJson(this);
}
