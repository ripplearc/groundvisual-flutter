import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_viewmodel.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

part 'trend_working_time_chart_event.dart';

part 'trend_working_time_chart_state.dart';

/// bloc to take events of touching a bar rod on the trend chart,
/// and emits state of corresponding images, group and rod id.
@injectable
class TrendWorkingTimeChartBloc
    extends Bloc<TrendWorkingTimeChartEvent, TrendWorkingTimeChartState> {
  final WorkingTimeTrendChartViewModel workingTimeTrendChartViewModel;
  final TrendChartBarConverter trendChartConverter;
  final WorkZoneMapBloc workZoneMapBloc;

  TrendWorkingTimeChartBloc(this.trendChartConverter,
      this.workingTimeTrendChartViewModel, @factoryParam this.workZoneMapBloc)
      : super(TrendWorkingTimeDataLoading(TrendPeriod.oneWeek));

  @override
  Stream<Transition<TrendWorkingTimeChartEvent, TrendWorkingTimeChartState>>
      transformEvents(
              Stream<TrendWorkingTimeChartEvent> events, transitionFn) =>
          events.switchMap((transitionFn));

  @override
  Stream<TrendWorkingTimeChartState> mapEventToState(
    TrendWorkingTimeChartEvent event,
  ) async* {
    if (event is SearchWorkingTimeOnTrend) {
      await for (var state in _yieldTrendWorkingTime(
          event.siteName, event.period, event.context)) yield state;
    } else if (event is SelectTrendChartBarRod) {
      _triggerWorkZoneBloc(event);
    }
  }

  Stream _yieldTrendWorkingTime(
      String siteName, TrendPeriod period, BuildContext context) {
    final loadingTrendFuture =
        Future.value(TrendWorkingTimeDataLoading(period));

    final trendWithChartFuture = Future(() async => await Future.delayed(
        Duration(seconds: 2),
        () => workingTimeTrendChartViewModel.trendWorkingTime(
            context, period)).then((chart) => TrendWorkingTimeDataLoaded(
          chart,
          siteName,
          period,
          DateTimeRange(
            start: Date.startOfToday - Duration(days: period.days()),
            end: Date.startOfToday,
          ),
        )));
    return Stream.fromFutures([loadingTrendFuture, trendWithChartFuture]);
  }

  void _triggerWorkZoneBloc(SelectTrendChartBarRod event) => trendChartConverter
      .convertToDateTime(event.range, event.period, event.groupId, event.rodId)
      .let((time) => workZoneMapBloc
          .add(SearchWorkZoneOnDate(event.siteName, time, event.context)));
}
