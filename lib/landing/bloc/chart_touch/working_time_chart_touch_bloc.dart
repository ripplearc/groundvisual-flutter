import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'working_time_chart_touch_event.dart';

part 'working_time_chart_touch_state.dart';

/// bloc to take events of touching a bar rod, and emits state of corresponding images.
@injectable
class WorkingTimeChartTouchBloc
    extends Bloc<WorkingTimeChartTouchEvent, WorkingTimeChartTouchState> {
  WorkingTimeChartTouchBloc() : super(WorkingTimeChartTouchInitial());

  @override
  Stream<WorkingTimeChartTouchState> mapEventToState(
    WorkingTimeChartTouchEvent event,
  ) async* {
    if (event is BarRodSelection) {
      yield WorkingTimeChartTouchShowThumbnail(event.groupId, event.rodId,
          'images/${event.groupId * 4 + event.rodId}.jpg');
      if (event.groupId % 2 == 0) {
        yield WorkingTimeChartTouchShowWorkArea(_getOddPolygons());
      } else {
        yield WorkingTimeChartTouchShowWorkArea(_getEvenPolygons());
      }
    } else {
      yield WorkingTimeChartTouchInitial();
    }
  }

  Set<Polygon> _getOddPolygons() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.626985, -82.982993));
    points.add(_createLatLng(42.627034, -82.982821));
    points.add(_createLatLng(42.62702, -82.982671));
    points.add(_createLatLng(42.626939, -82.982585));
    points.add(_createLatLng(42.626835, -82.982609));
    return {
      Polygon(
        polygonId: PolygonId("Test"),
        consumeTapEvents: true,
        strokeColor: Colors.red,
        strokeWidth: 5,
        fillColor: Colors.green,
        points: points,
      )
    };
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Set<Polygon> _getEvenPolygons() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(42.626584, -82.982633));
    points.add(_createLatLng(42.626669, -82.982341));
    points.add(_createLatLng(42.62659, -82.982024));
    points.add(_createLatLng(42.626436, -82.982024));
    points.add(_createLatLng(42.62641, -82.982311));
    return {
      Polygon(
        polygonId: PolygonId("Test_1"),
        consumeTapEvents: true,
        strokeColor: Colors.orange,
        strokeWidth: 5,
        fillColor: Colors.green,
        points: points,
      )
    };
  }
}
