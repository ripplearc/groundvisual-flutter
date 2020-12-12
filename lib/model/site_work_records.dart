import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'site_work_records.g.dart';

@JsonSerializable()
class SiteWorkZone {
  final String site;
  final List<UnitWorkZone> records;

  SiteWorkZone(this.site, this.records);

  factory SiteWorkZone.fromJson(Map<String, dynamic> json) =>
      _$SiteWorkZoneFromJson(json);

  Map<String, dynamic> toJson() => _$SiteWorkZoneToJson(this);
}

@JsonSerializable()
class UnitWorkZone {
  final DateTime date;

  final List<Region> regions;

  UnitWorkZone(this.date, this.regions);

  factory UnitWorkZone.fromJson(Map<String, dynamic> json) =>
      _$UnitWorkZoneFromJson(json);

  Map<String, dynamic> toJson() => _$UnitWorkZoneToJson(this);
}

class Region {
  final List<LatLng> points;

  Region(this.points);

  factory Region.fromJson(List<dynamic> json) =>
      Region(json.map((e) => LatLng.fromJson(e)).toList());

  dynamic toJson() => points.map((e) => e.toJson());
}
