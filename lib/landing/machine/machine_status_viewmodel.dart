import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/landing/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/messenger/machine_status_communicator.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_repository.dart';
import 'package:injectable/injectable.dart';

/// Viewmodel for determining the UI model of the machine working hours and online status.
@injectable
class MachineStatusViewModel {
  final MachineWorkingTimeRepository machineWorkingTimeRepository;
  final MachineStatusCommunicator machineStatusCommunicator;

  MachineStatusViewModel(
      this.machineWorkingTimeRepository, this.machineStatusCommunicator);

  Future<MachineStatusWorkingTime> getMachineWorkingTimeAtDate(
          String siteName, DateTime date) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(siteName, date.startOfDay, date.endOfDay)
          .then((time) => MachineStatusWorkingTime(time, {
                "312": machineStatusCommunicator.getMachineOnlineStatus("312"),
                "332": machineStatusCommunicator.getMachineOnlineStatus("332"),
              }));

  Future<MachineStatusWorkingTime> getMachineWorkingTimeAtPeriod(
          String siteName, TrendPeriod period) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(siteName, Date.startOfToday,
              Date.startOfToday.subtract(Duration(days: period.toInt())))
          .then((time) => MachineStatusWorkingTime(time, {
                "312": machineStatusCommunicator.getMachineOnlineStatus("312"),
                "332": machineStatusCommunicator.getMachineOnlineStatus("332"),
                "331": machineStatusCommunicator.getMachineOnlineStatus("331"),
              }));
}
