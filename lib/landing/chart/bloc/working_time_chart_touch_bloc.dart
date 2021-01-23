import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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
  final WorkZoneMapBloc workZoneMapBloc;

  WorkingTimeChartTouchBloc(this.workZoneMapViewModel, this.dailyChartConverter,
      this.trendChartConverter, this.workZoneMapBloc)
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
      _handleBarSelectionOnDate(event);
  }

  void _handleBarSelectionOnDate(TrendChartBarRodSelection event) {
    final date = trendChartConverter.convertToDateTime(
        event.range, event.period, event.groupId, event.rodId);
    workZoneMapBloc
        .add(SelectWorkZoneAtDate(event.siteName, date, event.context));
  }

  Stream<SiteSnapShotState> _handleBarSelectionOnTime(
      DateChartBarRodSelection event) {
    dailyChartConverter
        .convertToDateTime(event.date, event.groupId, event.rodId)
        .let((time) => workZoneMapBloc
            .add(SelectWorkZoneAtTime(event.siteName, time, event.context)));

    final thumbnailFuture = Future.value(SiteSnapShotThumbnail(
            event.groupId,
            event.rodId,
            'images/thumbnails/${event.groupId * 4 + event.rodId}.jpg'))
        .then((value) => Future.delayed(Duration(seconds: 1), () => value));

    return Stream.fromFutures([thumbnailFuture]);
  }
}
