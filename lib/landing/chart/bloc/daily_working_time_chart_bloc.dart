import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_viewmodel.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';
import 'package:groundvisual_flutter/landing/map/work_zone_map_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'daily_working_time_chart_event.dart';
part 'daily_working_time_chart_state.dart';

/// bloc to take events of touching a bar rod on the date or trend chart,
/// and emits state of corresponding images, group and rod id.
@LazySingleton()
class DailyWorkingTimeChartBloc
    extends Bloc<DailyWorkingTimeChartEvent, DailyWorkingTimeState> {
  final WorkZoneMapViewModel workZoneMapViewModel;
  final DailyChartBarConverter dailyChartConverter;
  final TrendChartBarConverter trendChartConverter;
  final WorkZoneMapBloc workZoneMapBloc;

  final WorkingTimeDailyChartViewModel workingTimeDailyChartViewModel;

  DailyWorkingTimeChartBloc(
      this.workZoneMapViewModel,
      this.dailyChartConverter,
      this.trendChartConverter,
      this.workZoneMapBloc,
      this.workingTimeDailyChartViewModel)
      : super(WorkingTimeChartLoading());

  @override
  Stream<Transition<DailyWorkingTimeChartEvent, DailyWorkingTimeState>>
      transformEvents(
              Stream<DailyWorkingTimeChartEvent> events, transitionFn) =>
          events
              .debounceTime(Duration(milliseconds: 100))
              .switchMap((transitionFn));

  @override
  Stream<DailyWorkingTimeState> mapEventToState(
    DailyWorkingTimeChartEvent event,
  ) async* {
    if (event is SearchWorkingTimeOnDate) {
      await for (var state
          in _yieldDailyWorkingTime(event.siteName, event.date, event.context))
        yield state;
    } else if (event is DailyChartBarRodSelection)
      await for (var state in _handleBarSelectionOnTime(event)) yield state;
    else if (event is TrendChartBarRodSelection)
      _handleBarSelectionOnDate(event);
  }

  Stream _yieldDailyWorkingTime(
      String siteName, DateTime date, BuildContext context) {
    final loadingFuture = Future.value(WorkingTimeChartLoading());
    final dailyWithChartFuture = Future.delayed(Duration(seconds: 2),
            () => workingTimeDailyChartViewModel.dailyWorkingTime(context))
        .then((dailyChart) =>
            WorkingTimeBarChartDataLoaded(dailyChart, siteName, date));

    return Stream.fromFutures([loadingFuture, dailyWithChartFuture]);
  }

  void _handleBarSelectionOnDate(TrendChartBarRodSelection event) {
    final date = trendChartConverter.convertToDateTime(
        event.range, event.period, event.groupId, event.rodId);
    workZoneMapBloc
        .add(SearchWorkZoneOnDate(event.siteName, date, event.context));
  }

  Stream<DailyWorkingTimeState> _handleBarSelectionOnTime(
      DailyChartBarRodSelection event) {
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
