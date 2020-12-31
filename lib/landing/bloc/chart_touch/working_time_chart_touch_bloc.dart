import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
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

import 'package:groundvisual_flutter/extensions/scoped.dart';

part 'working_time_chart_touch_event.dart';

part 'working_time_chart_touch_state.dart';

/// bloc to take events of touching a bar rod on the date or trend chart,
/// and emits state of corresponding images, group and rod id.
@injectable
class WorkingTimeChartTouchBloc
    extends Bloc<WorkingTimeChartTouchEvent, SiteSnapShotState> {
  final WorkZoneMapViewModel workZoneMapViewModel;
  final DailyChartBarConverter dailyChartConverter;
  final TrendChartBarConverter trendChartConverter;

  WorkingTimeChartTouchBloc(this.workZoneMapViewModel, this.dailyChartConverter,
      this.trendChartConverter)
      : super(WorkingTimeChartTouchInitial());

  @override
  Stream<Transition<WorkingTimeChartTouchEvent, SiteSnapShotState>>
      transformEvents(
              Stream<WorkingTimeChartTouchEvent> events, transitionFn) =>
          events
              .debounceTime(Duration(milliseconds: 100))
              .switchMap((transitionFn));

  @override
  Stream<SiteSnapShotState> mapEventToState(
    WorkingTimeChartTouchEvent event,
  ) async* {
    if (event is DateChartBarRodSelection)
      await for (var state in _handleBarSelectionOnTime(event)) yield state;
    else if (event is TrendChartBarRodSelection)
      await for (var state in _handleBarSelectionOnDate(event)) yield state;
    else if (event is NoBarRodSelection)
      await for (var state in _handleInitialLoadingOfChart(event)) yield state;
  }

  Stream<SiteSnapShotState> _handleInitialLoadingOfChart(
      NoBarRodSelection event) async* {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.siteName, Date.startOfToday, event.context),
      workZoneMapViewModel.getCameraPositionAtDate(
          event.siteName, Date.startOfToday)
    ]);
    yield SiteSnapShotWorkZone(result[0], result[1]);
  }

  Stream<SiteSnapShotState> _handleBarSelectionOnDate(
      TrendChartBarRodSelection event) async* {
    final selectedTime = trendChartConverter.convertToDateTime(
        event.range, event.period, event.groupId, event.rodId);
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.siteName, selectedTime, event.context),
      workZoneMapViewModel.getCameraPositionAtDate(event.siteName, selectedTime)
    ]);
    yield SiteSnapShotWorkZone(result[0], result[1]);
  }

  Stream<SiteSnapShotState> _handleBarSelectionOnTime(
      DateChartBarRodSelection event) {
    final thumbnailFuture = Future.value(SiteSnapShotThumbnail(event.groupId,
            event.rodId, 'images/${event.groupId * 4 + event.rodId}.jpg'))
        .then((value) => Future.delayed(Duration(seconds: 1), () => value));

    final workZoneFuture = Future(() async => dailyChartConverter
        .convertToDateTime(event.date, event.groupId, event.rodId)
        .let((selectedTime) async => await Future.wait<dynamic>([
              workZoneMapViewModel.getPolygonAtTime(
                  event.siteName, selectedTime, event.context),
              workZoneMapViewModel.getCameraPositionAtTime(
                  event.siteName, selectedTime)
            ]).then((result) => SiteSnapShotWorkZone(result[0], result[1]))));

    return Stream.fromFutures([thumbnailFuture, workZoneFuture]);
  }
}
