import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/messenger/machine_status_communicator.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Viewmodel for determining the UI model of the machine working hours and online status.
@injectable
class MachineStatusViewModel {
  final MachineWorkingTimeRepository machineWorkingTimeRepository;
  final MachineStatusCommunicator machineStatusCommunicator;

  MachineStatusViewModel(
      this.machineWorkingTimeRepository, this.machineStatusCommunicator);

  Future<MachineStatusOfWorkingTimeAndOnline> getMachineStatusAtDate(
          String siteName, DateTime date) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(siteName,
              DateTimeRange(start: date.startOfDay, end: date.endOfDay))
          .then((time) => MachineStatusOfWorkingTimeAndOnline(
              time, _getMachineOnlineStatuses(time.keys)));

  Future<MachineStatusOfWorkingTimeAndOnline> getMachineStatusAtPeriod(
          String siteName, TrendPeriod period) =>
      machineWorkingTimeRepository
          .getMachineWorkingTime(
              siteName,
              DateTimeRange(
                  start: Date.startOfToday.subDays(period.days),
                  end: Date.startOfToday))
          .then((time) => MachineStatusOfWorkingTimeAndOnline(
              time, _getMachineOnlineStatuses(time.keys)));

  Map<String, Stream<MachineOnlineStatus>> _getMachineOnlineStatuses(
          Iterable<String> machines) =>
      Map.fromIterable(machines,
          key: (m) => m,
          value: (m) => machineStatusCommunicator
              .getMachineOnlineStatus(m)
              .shareReplay());
}
