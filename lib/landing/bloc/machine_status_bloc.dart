import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'machine_status_event.dart';
part 'machine_status_state.dart';

@singleton
class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  MachineStatusBloc(this.machineWorkingTimeRepository)
      : super(MachineStatusInitial());

  final MachineWorkingTimeRepository machineWorkingTimeRepository;

  @override
  Stream<MachineStatusState> mapEventToState(
    MachineStatusEvent event,
  ) async* {
    if (event is SearchMachineStatusOnDate) {
      await for (var state
          in _handleSelectDateEvent(event.siteName, event.date)) yield state;
    } else if (event is SearchMachineStatueOnTrend) {
      await for (var state
          in _handleSelectTrendEvent(event.siteName, event.period)) yield state;
    }
  }

  Stream _handleSelectDateEvent(String siteName, DateTime date) {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final workingTimeFuture = machineWorkingTimeRepository
        .getMachineWorkingTime(siteName, date.startOfDay, date.endOfDay)
        .then((time) => MachineStatusWorkingTime(time));

    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }

  Stream _handleSelectTrendEvent(String siteName, TrendPeriod period) {
    final machineInitialFuture = Future.value(MachineStatusInitial());

    final workingTimeFuture = machineWorkingTimeRepository
        .getMachineWorkingTime(siteName, Date.startOfToday,
            Date.startOfToday.subtract(Duration(days: period.toInt())))
        .then((time) => MachineStatusWorkingTime(time));

    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }
}
