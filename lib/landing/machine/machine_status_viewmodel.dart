import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/landing/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MachineStatusViewModel {
  final MachineWorkingTimeRepository machineWorkingTimeRepository;

  MachineStatusViewModel(this.machineWorkingTimeRepository);

  Future<MachineStatusWorkingTime> getMachineWorkingTimeAtDate(
          String siteName, DateTime date) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(siteName, date.startOfDay, date.endOfDay)
          .then((time) => MachineStatusWorkingTime(time));

  Future<MachineStatusWorkingTime> getMachineWorkingTimeAtPeriod(
          String siteName, TrendPeriod period) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(siteName, Date.startOfToday,
              Date.startOfToday.subtract(Duration(days: period.toInt())))
          .then((time) => MachineStatusWorkingTime(time));
}
