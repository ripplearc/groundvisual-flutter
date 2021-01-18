import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../work_zone_map_viewmodel.dart';

part 'work_zone_map_event.dart';

part 'work_zone_map_state.dart';

@singleton
class WorkZoneMapBloc extends Bloc<WorkZoneMapEvent, WorkZoneMapState> {
  final WorkZoneMapViewModel workZoneMapViewModel;

  WorkZoneMapBloc(this.workZoneMapViewModel) : super(WorkZoneMapInitial());

  @override
  Stream<Transition<WorkZoneMapEvent, WorkZoneMapState>> transformEvents(
          Stream<WorkZoneMapEvent> events, transitionFn) =>
      events.switchMap(transitionFn);

  @override
  Stream<WorkZoneMapState> mapEventToState(
    WorkZoneMapEvent event,
  ) async* {
    if (event is SelectWorkZoneAtTime) {
      yield await _handleSelectWorkZoneAtTime(event);
    } else {
      yield await _handleSelectWorkZoneAtDate(event);
    }
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtDate(
      SelectWorkZoneAtDate event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.site, event.date, event.context),
      workZoneMapViewModel.getCameraPositionAtDate(event.site, event.date)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtTime(
      SelectWorkZoneAtTime event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.site, event.time, event.context),
      workZoneMapViewModel.getCameraPositionAtDate(event.site, event.time)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }
}
