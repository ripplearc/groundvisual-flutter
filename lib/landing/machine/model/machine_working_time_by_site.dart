import 'package:freezed_annotation/freezed_annotation.dart';

part 'machine_working_time_by_site.g.dart';

@JsonSerializable()
class SiteMachineWorkingTime {
  final String site;

  final List<_DurationMachineWorkingTime> records;

  SiteMachineWorkingTime(this.site, this.records);

  factory SiteMachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$SiteMachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$SiteMachineWorkingTimeToJson(this);
}

@JsonSerializable()
class _DurationMachineWorkingTime {
  final DateTime startDate;
  final DateTime endDate;
  final int durationInSeconds;
  final List<_MachineWorkingTime> machines;

  _DurationMachineWorkingTime(
      this.startDate, this.endDate, this.durationInSeconds, this.machines);

  factory _DurationMachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$_DurationMachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$_DurationMachineWorkingTimeToJson(this);
}

@JsonSerializable()
class _MachineWorkingTime {
  final String name;
  final int workingInSeconds;
  final int idlingInSeconds;

  _MachineWorkingTime(this.name, this.workingInSeconds, this.idlingInSeconds);

  factory _MachineWorkingTime.fromJson(Map<String, dynamic> json) =>
      _$_MachineWorkingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$_MachineWorkingTimeToJson(this);
}
