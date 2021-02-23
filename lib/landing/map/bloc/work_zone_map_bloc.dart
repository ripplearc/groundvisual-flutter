import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'work_zone_map_viewmodel.dart';

part 'work_zone_map_event.dart';

part 'work_zone_map_state.dart';

/// Bloc to control the the WorkZone widget.
/// Both SelectedSiteBloc and WorkingTimeChartTouchBloc signal events to WorkZoneMapBloc.
@injectable
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
    if (event is SearchWorkZoneAtTime) {
      yield await _handleSelectWorkZoneAtTime(event);
    } else if (event is SearchWorkZoneOnDate) {
      yield await _handleSelectWorkZoneAtDate(event);
    } else if (event is SearchWorkZoneAtPeriod) {
      yield await _handleSelectWorkZoneAtPeriod(event);
    }
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtPeriod(
      SearchWorkZoneAtPeriod event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtPeriod(
          event.site, event.date, event.period, event.context),
      workZoneMapViewModel.getCameraPositionAtPeriod(
          event.site, event.date, event.period)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtDate(
      SearchWorkZoneOnDate event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.site, event.date, event.context),
      workZoneMapViewModel.getCameraPositionAtDate(event.site, event.date)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtTime(
      SearchWorkZoneAtTime event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtTime(
          event.site, event.time, event.context),
      workZoneMapViewModel.getCameraPositionAtTime(event.site, event.time)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

}
