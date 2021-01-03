import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/machine/model/machine_working_time_by_site.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_service.dart';
import 'package:injectable/injectable.dart';

/// Repository for managing the working time of machines at a site. It can be
/// an individual date or an period.
/// All repository implementations should be singleton to eliminate duplicated network call.
abstract class MachineWorkingTimeRepository {
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
      String siteName, DateTime startTime, DateTime endTime);
}

@Singleton(as: MachineWorkingTimeRepository)
class MachineWorkingTimeRepositoryImpl extends MachineWorkingTimeRepository {
  final MachineWorkingTimeService machineWorkingTimeService;
  static const normalTenWorkingHourPerDayInSeconds = 36000;
  static const secondsPerDay = 86400;

  MachineWorkingTimeRepositoryImpl(this.machineWorkingTimeService);

  @override
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
          String siteName, DateTime startTime, DateTime endTime) =>
      Future.delayed(
          Duration(milliseconds: 1000),
          () => fetchMachineWorkingTime(siteName, startTime, endTime).then(
              (value) => value.records
                  .firstWhere((durationMachineWorkingTime) =>
                      durationMachineWorkingTime.durationInSeconds ==
                      max(startTime.differenceInSeconds(endTime).abs(),
                          secondsPerDay))
                  .machines
                  .let((items) => _convertToUnitWorkingTime(startTime.differenceInDays(endTime).abs() * normalTenWorkingHourPerDayInSeconds, items))));

  Future<SiteMachineWorkingTime> fetchMachineWorkingTime(
          String siteName, DateTime startTime, DateTime endTime) =>
      startTime.isToday
          ? machineWorkingTimeService
              .getMachineWorkingTimeOfRecentBySite(siteName)
          : machineWorkingTimeService.getMachineWorkingTimeOfDateBySite(
              siteName, startTime);

  Map<String, UnitWorkingTime> _convertToUnitWorkingTime(
          int duration, List times) =>
      Map.fromIterable(times,
          key: (item) => item.name,
          value: (item) => UnitWorkingTime(
              duration, item.workingInSeconds, item.idlingInSeconds));
}
