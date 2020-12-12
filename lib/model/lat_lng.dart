import 'package:json_annotation/json_annotation.dart';
part 'lat_lng.g.dart';

@JsonSerializable()
class LatLng2 {
  LatLng2({
    this.lat,
    this.lng,
  });

  factory LatLng2.fromJson(Map<String, dynamic> json) => _$LatLng2FromJson(json);
  Map<String, dynamic> toJson() => _$LatLng2ToJson(this);

  final double lat;
  final double lng;
}
