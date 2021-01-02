import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/machine_status_viewmodel.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'machine_status_event.dart';
part 'machine_status_state.dart';

@singleton
class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  MachineStatusBloc(this.machineStatusViewModel)
      : super(MachineStatusInitial());
  final MachineStatusViewModel machineStatusViewModel;

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

  Stream<MachineStatusState> _handleSelectDateEvent(String siteName, DateTime date) {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final workingTimeFuture =
        machineStatusViewModel.getMachineWorkingTimeAtDate(siteName, date);

    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }

  Stream<MachineStatusState> _handleSelectTrendEvent(String siteName, TrendPeriod period) {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final workingTimeFuture =
        machineStatusViewModel.getMachineWorkingTimeAtPeriod(siteName, period);

    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }
}
