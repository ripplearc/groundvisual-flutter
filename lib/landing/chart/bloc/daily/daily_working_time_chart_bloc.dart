import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_transformer.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_viewmodel.dart';
import 'package:groundvisual_flutter/landing/chart/model/highlighted_bar.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play/play_digest_bloc.dart';
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
  final SelectedSiteBloc? selectedSiteBloc;
  final PlayDigestBloc? playDigestBloc;
  StreamSubscription? _selectedSiteSubscription;
  StreamSubscription? _playDigestSubscription;

  final StreamController<HighlightedBar> _highlightController =
      StreamController.broadcast();

  DailyWorkingTimeChartBloc(
    this.dailyChartConverter,
    this.workingTimeDailyChartViewModel,
    @factoryParam this.selectedSiteBloc,
    @factoryParam this.playDigestBloc,
  ) : super(DailyWorkingTimeDataLoading()) {
    _listenToSelectedSite();
    _listenToPlayDigest();
  }

  @override
  Stream<Transition<DailyWorkingTimeChartEvent, DailyWorkingTimeState>>
      transformEvents(
              Stream<DailyWorkingTimeChartEvent> events, transitionFn) =>
          events.switchMap((transitionFn));

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc?.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState? state) {
    if (state is SelectedSiteAtDate) {
      add(SearchWorkingTimeOnDate(state.siteName, state.date));
    }
  }

  void _listenToPlayDigest() {
    _playDigestSubscription = playDigestBloc?.stream.listen((state) {
      if (state is PlayDigestShowImage) {
        final indices = state.images.isEmpty
            ? Tuple2(-1, -1)
            : dailyChartConverter.convertToIndices(state.images.time);
        add(SelectDailyChartBarRod(
            indices.item1, indices.item2, state.siteName, state.date,
            showThumbnail: false));
      }
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
      _handleBarSelectionOnTime(event);
  }

  Stream<DailyWorkingTimeState> _yieldDailyWorkingTime(
      String siteName, DateTime date) {
    final loadingFuture = Future.value(DailyWorkingTimeDataLoading());
    final dailyWithChartFuture = Future.delayed(Duration(seconds: 2),
            () => workingTimeDailyChartViewModel.dailyWorkingTime())
        .then((dailyChart) => DailyWorkingTimeDataLoaded(
            dailyChart, siteName, date, _highlightController.stream));

    return Stream.fromFutures([loadingFuture, dailyWithChartFuture]);
  }

  void _handleBarSelectionOnTime(SelectDailyChartBarRod event) =>
      dailyChartConverter
          .convertToDateTime(event.date, event.groupId, event.rodId)
          .let((time) => _highlightController.sink.add(HighlightedBar(
              groupId: event.groupId,
              rodId: event.rodId,
              siteName: event.siteName,
              time: time)));

  @override
  Future<void> close() {
    _highlightController.close();
    _selectedSiteSubscription?.cancel();
    _playDigestSubscription?.cancel();
    return super.close();
  }
}
