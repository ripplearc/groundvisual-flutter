import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/landing/machine/model/machine_working_time_by_site.dart';
import 'package:injectable/injectable.dart';

abstract class MachineWorkingTimeService {
  Future<SiteMachineWorkingTime> getMachineWorkingTimeBySite(String siteName);
}

@Injectable(as: MachineWorkingTimeService)
class MachineWorkingTimeServiceImpl extends MachineWorkingTimeService {
  @override
  Future<SiteMachineWorkingTime> getMachineWorkingTimeBySite(String siteName) =>
      rootBundle
          .loadString('assets/mock_response/machine_working_time.json')
          .then((value) => json.decode(value))
          .then((decoded) {
        return SiteMachineWorkingTime.fromJson(decoded);
      });
}
