import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/machine/model/machine_working_time_by_site.dart';
import 'package:groundvisual_flutter/models/machine_unit_working_time.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_service.dart';
import 'package:injectable/injectable.dart';

/// Repository for managing the working time of machines at a site. It can be
/// an date or an period.
/// All repository implementations should be singleton to eliminate duplicated network call.
abstract class MachineWorkingTimeRepository {
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
      String siteName, DateTimeRange dateTimeRange);
}

@LazySingleton(as: MachineWorkingTimeRepository)
class MachineWorkingTimeRepositoryImpl extends MachineWorkingTimeRepository {
  final MachineWorkingTimeService machineWorkingTimeService;
  static const normalTenWorkingHourPerDayInSeconds = 36000;
  static const secondsPerDay = 86400;

  MachineWorkingTimeRepositoryImpl(this.machineWorkingTimeService);

  @override
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
          String siteName, DateTimeRange dateTimeRange) =>
      Future.delayed(
          Duration(milliseconds: 1000),
          () => _fetchMachineWorkingTime(siteName, dateTimeRange.start, dateTimeRange.end)
              .then((value) => value.records
                  .firstWhere((durationMachineWorkingTime) =>
                      durationMachineWorkingTime.durationInSeconds ==
                      max(dateTimeRange.start.differenceInSeconds(dateTimeRange.end).abs(),
                          secondsPerDay))
                  .machines
                  .let((items) => _convertToUnitWorkingTime(dateTimeRange.start.differenceInDays(dateTimeRange.end).abs() * normalTenWorkingHourPerDayInSeconds, items))));

  Future<SiteMachineWorkingTime> _fetchMachineWorkingTime(
          String siteName, DateTime startTime, DateTime endTime) =>
      startTime.isSameDay(endTime)
          ? machineWorkingTimeService.getMachineWorkingTimeOfDateBySite(
              siteName, startTime)
          : machineWorkingTimeService
              .getMachineWorkingTimeOfRecentBySite(siteName);

  Map<String, UnitWorkingTime> _convertToUnitWorkingTime(
          int duration, List times) =>
      Map.fromIterable(times,
          key: (item) => item.muid,
          value: (item) => UnitWorkingTime(
              duration, item.workingInSeconds, item.idlingInSeconds));
}
