import 'package:freezed_annotation/freezed_annotation.dart';

part 'machine_working_time_by_site.g.dart';

@JsonSerializable()
class SiteMachineWorkingTime {
  final String site;

  final List<DurationMachineWorkingTime> records;

  SiteMachineWorkingTime(this.site, this.records);

  factory SiteMachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$SiteMachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$SiteMachineWorkingTimeToJson(this);
}

@JsonSerializable()
class DurationMachineWorkingTime {
  final DateTime startDate;
  final DateTime endDate;
  final int durationInSeconds;
  final List<MachineWorkingTime> machines;

  DurationMachineWorkingTime(
      this.startDate, this.endDate, this.durationInSeconds, this.machines);

  factory DurationMachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$DurationMachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$DurationMachineWorkingTimeToJson(this);
}

@JsonSerializable()
class MachineWorkingTime {
  final String name;
  final int workingInSeconds;
  final int idlingInSeconds;

  MachineWorkingTime(this.name, this.workingInSeconds, this.idlingInSeconds);

  factory MachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$MachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$MachineWorkingTimeToJson(this);
}
