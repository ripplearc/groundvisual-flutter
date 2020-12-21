import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
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
  final DailyChartBarConverter dailyChartConverter;
  final TrendChartBarConverter trendChartConverter;

  WorkingTimeChartTouchBloc(this.workZoneMapViewModel, this.dailyChartConverter, this.trendChartConverter)
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
    if (event is DateChartBarRodSelection) {
      await for (var state in _handleBarSelectionOnDateChart(event))
        yield state;
    } else if (event is TrendChartBarRodSelection) {
      await for (var state in _handleBarSelectionOnTrendChart(event))
        yield state;
    } else if (event is NoBarRodSelection) {
      final cameraPosition = await workZoneMapViewModel.getCameraPosition(
          event.siteName, event.date);
      yield SiteSnapShotWorkArea(Set(), cameraPosition);
    }
  }

  Stream<SiteSnapShotState> _handleBarSelectionOnTrendChart(
      TrendChartBarRodSelection event) async* {

    final selectedTime =
        trendChartConverter.convertToDateTime(event.range, event.period, event.groupId, event.rodId);
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygon(
          event.siteName, selectedTime, event.context),
      workZoneMapViewModel.getCameraPosition(event.siteName, selectedTime)
    ]);
    yield SiteSnapShotWorkArea(result[0], result[1]);
  }

  Stream<SiteSnapShotState> _handleBarSelectionOnDateChart(
      DateChartBarRodSelection event) async* {
    yield SiteSnapShotThumbnail(event.groupId, event.rodId,
        'images/${event.groupId * 4 + event.rodId}.jpg');

    final selectedTime =
        dailyChartConverter.convertToDateTime(event.date, event.groupId, event.rodId);
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygon(
          event.siteName, selectedTime, event.context),
      workZoneMapViewModel.getCameraPosition(event.siteName, selectedTime)
    ]);
    yield SiteSnapShotWorkArea(result[0], result[1]);
  }
}
