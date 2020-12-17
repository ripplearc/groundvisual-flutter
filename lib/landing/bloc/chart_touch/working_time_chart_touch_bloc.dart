import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'working_time_chart_touch_event.dart';

part 'working_time_chart_touch_state.dart';

/// bloc to take events of touching a bar rod, and emits state of corresponding images.
@injectable
class WorkingTimeChartTouchBloc
    extends Bloc<WorkingTimeChartTouchEvent, SiteSnapShotState> {
  final WorkZoneMapViewModel workZoneMapViewModel;

  WorkingTimeChartTouchBloc(this.workZoneMapViewModel)
      : super(WorkingTimeChartTouchInitial());

  @override
  Stream<Transition<WorkingTimeChartTouchEvent, SiteSnapShotState>>
      transformEvents(
              Stream<WorkingTimeChartTouchEvent> events, transitionFn) =>
          events.switchMap((transitionFn));

  @override
  Stream<SiteSnapShotState> mapEventToState(
    WorkingTimeChartTouchEvent event,
  ) async* {
    if (event is BarRodSelection) {
      yield SiteSnapShotThumbnail(event.groupId, event.rodId,
          'images/${event.groupId * 4 + event.rodId}.jpg');

      if (event.groupId % 3 == 0) {
        List<dynamic> result = await Future.wait<dynamic>([
          workZoneMapViewModel.getOddPolygons(event.context),
          workZoneMapViewModel.getCameraPosition("")
        ]);
        yield SiteSnapShotWorkArea(result[0], result[1]);
      } /*else if (event.groupId % 3 == 1) {
        List<dynamic> result = await Future.wait<dynamic>([
          workZoneMapViewModel.getEvenPolygons(event.context),
          workZoneMapViewModel.getCameraPosition("")
        ]);
        yield SiteSnapShotWorkArea(result[0], result[1]);
      } */else {
        List<dynamic> result = await Future.wait<dynamic>([
          workZoneMapViewModel.getPentonPolygons(event.context),
          workZoneMapViewModel.getPentonCameraPosition("")
        ]);
        yield SiteSnapShotWorkArea(result[0], result[1]);
      }
    } else if (event is NoBarRodSelection) {
      final cameraPosition = await workZoneMapViewModel.getCameraPosition("");
      yield SiteSnapShotWorkArea(Set(), cameraPosition);
    }
  }
}
