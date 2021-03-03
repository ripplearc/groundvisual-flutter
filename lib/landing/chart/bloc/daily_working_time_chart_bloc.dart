import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_viewmodel.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

part 'daily_working_time_chart_event.dart';

part 'daily_working_time_chart_state.dart';

/// bloc to take events of touching a bar rod on the date chart,
/// and emits state of corresponding images, group and rod id.
@injectable
class DailyWorkingTimeChartBloc
    extends Bloc<DailyWorkingTimeChartEvent, DailyWorkingTimeState> {
  final WorkingTimeDailyChartViewModel workingTimeDailyChartViewModel;
  final DailyChartBarConverter dailyChartConverter;
  final SelectedSiteBloc selectedSiteBloc;
  StreamSubscription _selectedSiteSubscription;

  final StreamController<Tuple2<int, int>> _highlightController =
      StreamController.broadcast();

  DailyWorkingTimeChartBloc(
    this.dailyChartConverter,
    this.workingTimeDailyChartViewModel,
    this.selectedSiteBloc,
  ) : super(DailyWorkingTimeDataLoading()) {
    _listenToSelectedSite();
  }

  @override
  Stream<Transition<DailyWorkingTimeChartEvent, DailyWorkingTimeState>>
      transformEvents(
              Stream<DailyWorkingTimeChartEvent> events, transitionFn) =>
          events.switchMap((transitionFn));

  void _listenToSelectedSite() {
    _selectedSiteSubscription = selectedSiteBloc?.listen((state) {
      if (state is SelectedSiteAtDate) {
        add(SearchWorkingTimeOnDate(state.siteName, state.date));
      }
      // else if (state is SelectedSiteAtTrend) {
      //   add(SearchWorkZoneAtPeriod(
      //       state.siteName, Date.startOfToday, state.period));
      // }
    });
  }

  @override
  Stream<DailyWorkingTimeState> mapEventToState(
    DailyWorkingTimeChartEvent event,
  ) async* {
    if (event is SearchWorkingTimeOnDate) {
      await for (var state
          in _yieldDailyWorkingTime(event.siteName, event.date)) yield state;
    } else if (event is SelectDailyChartBarRod)
      await for (var state in _handleBarSelectionOnTime(event)) yield state;
  }

  Stream _yieldDailyWorkingTime(String siteName, DateTime date) {
    final loadingFuture = Future.value(DailyWorkingTimeDataLoading());
    final dailyWithChartFuture = Future.delayed(Duration(seconds: 2),
            () => workingTimeDailyChartViewModel.dailyWorkingTime())
        .then((dailyChart) => DailyWorkingTimeDataLoaded(
            dailyChart, siteName, date, _highlightController.stream));

    return Stream.fromFutures([loadingFuture, dailyWithChartFuture]);
  }

  Stream<DailyWorkingTimeState> _handleBarSelectionOnTime(
      SelectDailyChartBarRod event) {
    _highlightController.sink.add(Tuple2(event.groupId, event.rodId));
    Future<DailyWorkingTimeBarRodHighlighted> highlightFuture =
        dailyChartConverter
            .convertToDateTime(event.date, event.groupId, event.rodId)
            .let((time) => Future.value(DailyWorkingTimeBarRodHighlighted(
                event.groupId,
                event.rodId,
                event.siteName,
                time,
                event.context)));

    final thumbnailFuture = Future.delayed(Duration(milliseconds: 200)).then(
        (_) => SiteSnapShotThumbnailLoaded(event.groupId, event.rodId,
            'images/thumbnails/${event.groupId * 4 + event.rodId}.jpg'));

    return event.showThumbnail
        ? Stream.fromFutures([
            highlightFuture,
            Future.value(SiteSnapShotLoading()),
            thumbnailFuture
          ])
        : Stream.value(SiteSnapShotHiding());
  }

  @override
  Future<void> close() {
    _highlightController.close();
    _selectedSiteSubscription.cancel();
    return super.close();
  }
}
