import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_transformer.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'trend_working_time_chart_event.dart';
part 'trend_working_time_chart_state.dart';

/// bloc to take events of touching a bar rod on the trend chart,
/// and emits state of corresponding images, group and rod id.
@injectable
class TrendWorkingTimeChartBloc
    extends Bloc<TrendWorkingTimeChartEvent, TrendWorkingTimeChartState> {
  final WorkingTimeTrendChartViewModel workingTimeTrendChartViewModel;
  final TrendChartBarConverter trendChartConverter;
  final SelectedSiteBloc selectedSiteBloc;
  StreamSubscription _selectedSiteSubscription;

  TrendWorkingTimeChartBloc(this.trendChartConverter,
      this.workingTimeTrendChartViewModel, @factoryParam this.selectedSiteBloc)
      : super(TrendWorkingTimeDataLoading(TrendPeriod.oneWeek)) {
    _listenToSelectedSite();
  }

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream?.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState state) {
    if (state is SelectedSiteAtTrend) {
      add(SearchWorkingTimeOnTrend(state.siteName, state.period));
    }
  }

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
      await for (var state
          in _yieldTrendWorkingTime(event.siteName, event.period)) yield state;
    } else if (event is SelectTrendChartBarRod) {
      yield await _handleBarSelectionOnDate(event);
    }
  }

  Stream _yieldTrendWorkingTime(String siteName, TrendPeriod period) {
    final loadingTrendFuture =
        Future.value(TrendWorkingTimeDataLoading(period));

    final trendWithChartFuture = Future(() async => await Future.delayed(
            Duration(seconds: 2),
            () => workingTimeTrendChartViewModel.trendWorkingTime(period))
        .then((chart) => TrendWorkingTimeDataLoaded(
            chart,
            siteName,
            period,
            DateTimeRange(
              start: Date.startOfToday - Duration(days: period.days()),
              end: Date.startOfToday,
            ))));
    return Stream.fromFutures([loadingTrendFuture, trendWithChartFuture]);
  }

  Future<TrendWorkingTimeChartState> _handleBarSelectionOnDate(
          SelectTrendChartBarRod event) =>
      trendChartConverter
          .convertToDateTime(
              event.range, event.period, event.groupId, event.rodId)
          .let((time) => Future.value(
              TrendWorkingTimeBarRodHighlighted(event.siteName, time)));

  @override
  Future<void> close() {
    _selectedSiteSubscription.cancel();
    return super.close();
  }
}
