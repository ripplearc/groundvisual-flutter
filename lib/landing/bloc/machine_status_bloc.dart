import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

part 'machine_status_event.dart';

part 'machine_status_state.dart';

@singleton
class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  MachineStatusBloc() : super(MachineStatusInitial());

  @override
  Stream<MachineStatusState> mapEventToState(
    MachineStatusEvent event,
  ) async* {
    if (event is SearchMachineStatusOnDate) {
      await for (var state in _handleSelectDateEvent()) yield state;
    } else if (event is SearchMachineStatueOnTrend) {
      await for (var state in _handleSelectTrendEvent()) yield state;
    }
  }

  Stream _handleSelectDateEvent() {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final workingTimeFuture = Future.delayed(
        Duration(milliseconds: 1000),
        () => Random().let((random) => WorkingTimeAtSelectedSite({
              "332": UnitWorkingTime(
                  720, random.nextInt(720), random.nextInt(240)),
              "312": UnitWorkingTime(
                  720, random.nextInt(720), random.nextInt(240)),
            })));

    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }

  Stream _handleSelectTrendEvent() {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final workingTimeFuture = Future.delayed(
        Duration(milliseconds: 1000),
        () => Random().let((random) => WorkingTimeAtSelectedSite({
              "332": UnitWorkingTime(
                  7200, random.nextInt(7200), random.nextInt(2400)),
              "312": UnitWorkingTime(
                  7200, random.nextInt(7200), random.nextInt(2400)),
              "PC240": UnitWorkingTime(
                  7200, random.nextInt(7200), random.nextInt(2400))
            })));
    return Stream.fromFutures([machineInitialFuture, workingTimeFuture]);
  }
}
