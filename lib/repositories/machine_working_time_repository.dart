import 'dart:math';

import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_service.dart';
import 'package:injectable/injectable.dart';
import 'package:dart_date/dart_date.dart';

abstract class MachineWorkingTimeRepository {
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
      String siteName, DateTime startTime, DateTime endTime);
}

@Singleton(as: MachineWorkingTimeRepository)
class MachineWorkingTimeRepositoryImpl extends MachineWorkingTimeRepository {
  final MachineWorkingTimeService machineWorkingTimeService;

  MachineWorkingTimeRepositoryImpl(this.machineWorkingTimeService);

  @override
  Future<Map<String, UnitWorkingTime>> getMachineWorkingTime(
      String siteName, DateTime startTime, DateTime endTime) async {
    final foo = await machineWorkingTimeService.getMachineWorkingTimeBySite(siteName);
    return Future.delayed(Duration(milliseconds: 1000),
        () => _fakeWorkingTime(endTime, startTime));
  }

  Future<Map<String, UnitWorkingTime>> _fakeWorkingTime(
      DateTime endTime, DateTime startTime) async {
    final differenceInDays = endTime.differenceInDays(startTime).abs();
    final random = Random();
    if (differenceInDays < 1) {
      return {
        "332": UnitWorkingTime(720, random.nextInt(720), random.nextInt(240)),
        "312": UnitWorkingTime(720, random.nextInt(720), random.nextInt(240)),
      };
    } else if (differenceInDays < 8) {
      return {
        "332":
            UnitWorkingTime(5040, random.nextInt(5040), random.nextInt(1440)),
        "312":
            UnitWorkingTime(5040, random.nextInt(5040), random.nextInt(1440)),
      };
    } else if (differenceInDays < 15) {
      return {
        "332":
            UnitWorkingTime(10080, random.nextInt(10080), random.nextInt(2880)),
        "312":
            UnitWorkingTime(10080, random.nextInt(10080), random.nextInt(2880)),
      };
    } else if (differenceInDays < 31) {
      return {
        "332":
            UnitWorkingTime(20160, random.nextInt(20160), random.nextInt(5760)),
        "312":
            UnitWorkingTime(20160, random.nextInt(20160), random.nextInt(5760)),
      };
    } else {
      return {
        "332": UnitWorkingTime(
            40320, random.nextInt(40320), random.nextInt(11520)),
        "312": UnitWorkingTime(
            40320, random.nextInt(40320), random.nextInt(11520)),
      };
    }
  }
}
