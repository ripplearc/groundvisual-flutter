import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_viewmodel.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';
import 'package:groundvisual_flutter/models/machine_unit_working_time.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'machine_status_event.dart';

part 'machine_status_state.dart';

/// MachineStatusBloc computes the state of the machine working time and online notification
/// It has to be singleton because it needs to receive events from the SelectedSiteBloc, and
/// we have to make sure the copy receives events and the copy provided in the BlocBuilder is the same.
@injectable
class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  MachineStatusBloc(
      this.machineStatusViewModel, @factoryParam this.selectedSiteBloc)
      : super(MachineStatusInitial()) {
    _listenToSelectedSite();
  }

  final MachineStatusViewModel machineStatusViewModel;
  final SelectedSiteBloc selectedSiteBloc;
  StreamSubscription _selectedSiteSubscription;

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream?.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState state) {
    if (state is SelectedSiteAtDate) {
      add(SearchMachineStatusOnDate(state.siteName, state.date));
    } else if (state is SelectedSiteAtTrend) {
      add(SearchMachineStatueOnTrend(state.siteName, state.period));
    }
  }

  @override
  Stream<Transition<MachineStatusEvent, MachineStatusState>> transformEvents(
          Stream<MachineStatusEvent> events, transitionFn) =>
      events.switchMap((transitionFn));

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

  Stream<MachineStatusState> _handleSelectDateEvent(
      String siteName, DateTime date) {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final machineStatusFuture =
        machineStatusViewModel.getMachineStatusAtDate(siteName, date);

    return Stream.fromFutures([machineInitialFuture, machineStatusFuture]);
  }

  Stream<MachineStatusState> _handleSelectTrendEvent(
      String siteName, TrendPeriod period) {
    final machineInitialFuture = Future.value(MachineStatusInitial());
    final machineStatusFuture =
        machineStatusViewModel.getMachineStatusAtPeriod(siteName, period);

    return Stream.fromFutures([machineInitialFuture, machineStatusFuture]);
  }

  @override
  Future<void> close() {
    _selectedSiteSubscription.cancel();
    return super.close();
  }
}
