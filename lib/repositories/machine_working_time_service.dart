import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/landing/machine/model/machine_working_time_by_site.dart';
import 'package:injectable/injectable.dart';

abstract class MachineWorkingTimeService {
  Future<SiteMachineWorkingTime> getMachineWorkingTimeOfRecentBySite(
      String siteName);

  Future<SiteMachineWorkingTime> getMachineWorkingTimeOfDateBySite(
      String siteName, DateTime date);
}

@Injectable(as: MachineWorkingTimeService)
class MachineWorkingTimeServiceImpl extends MachineWorkingTimeService {
  @override
  Future<SiteMachineWorkingTime> getMachineWorkingTimeOfRecentBySite(
          String siteName) =>
      rootBundle
          .loadString('assets/mock_response/machine_working_time_recent.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteMachineWorkingTime.fromJson(decoded));

  Future<SiteMachineWorkingTime> getMachineWorkingTimeOfDateBySite(
          String siteName, DateTime date) =>
      rootBundle
          .loadString('assets/mock_response/machine_working_time_date.json')
          .then((value) => json.decode(value))
          .then((decoded) => SiteMachineWorkingTime.fromJson(decoded));
}
