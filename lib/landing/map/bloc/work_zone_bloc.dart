import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend/trend_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/model/highlighted_bar.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'work_zone_map_viewmodel.dart';

part 'work_zone_event.dart';

part 'work_zone_state.dart';

/// Bloc to control the the WorkZone widget.
/// Both SelectedSiteBloc and WorkingTimeChartTouchBloc signal events to WorkZoneMapBloc.
@injectable
class WorkZoneBloc extends Bloc<WorkZoneEvent, WorkZoneState> {
  final WorkZoneMapViewModel workZoneMapViewModel;
  final DailyChartBarConverter dailyChartBarConverter;

  final DailyWorkingTimeChartBloc? dailyWorkingTimeChartBloc;
  final TrendWorkingTimeChartBloc? trendWorkingTimeChartBloc;
  final SelectedSiteBloc? selectedSiteBloc;
  StreamSubscription? _dailyChartSubscription;
  StreamSubscription? _trendChartSubscription;
  StreamSubscription? _selectedSiteSubscription;

  WorkZoneBloc(this.workZoneMapViewModel, this.dailyChartBarConverter,
      {this.selectedSiteBloc,
      this.dailyWorkingTimeChartBloc,
      this.trendWorkingTimeChartBloc})
      : super(WorkZoneInitial()) {
    _listenToSelectedSite();
    _listenToDailyChartSelection();
    _listenToTrendChartSelection();
  }

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc?.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState? state) {
    if (state is SelectedSiteAtDate) {
      add(SearchWorkZoneOnDate(state.siteName, state.date));
    } else if (state is SelectedSiteAtTrend) {
      add(SearchWorkZoneAtPeriod(
          state.siteName, Date.startOfToday, state.period));
    }
  }

  void _listenToTrendChartSelection() {
    _trendChartSubscription = trendWorkingTimeChartBloc?.stream
        .switchMap((value) => value is TrendWorkingTimeDataLoaded
            ? value.highlightRodBarStream.map<WorkZoneEvent>((highlight) =>
                SearchWorkZoneOnDate(highlight.siteName, highlight.time))
            : Stream.empty())
        .listen((event) => add(event));
  }

  void _listenToDailyChartSelection() {
    _dailyChartSubscription = dailyWorkingTimeChartBloc?.stream
        .switchMap((value) => value is DailyWorkingTimeDataLoaded
            ? value.highlightRodBarStream
                .map<WorkZoneEvent>((highlight) => HighlightWorkZoneOfTime(
                      DateTimeRange(
                          start: highlight.time,
                          end: _endTimeOfHighlightedRod(highlight)),
                    ))
            : Stream.empty())
        .listen((event) => add(event));
  }

  DateTime _endTimeOfHighlightedRod(HighlightedBar highlight) => highlight.time
      .add(Duration(seconds: dailyChartBarConverter.secondsPerRod));

  @override
  Stream<Transition<WorkZoneEvent, WorkZoneState>> transformEvents(
          Stream<WorkZoneEvent> events, transitionFn) =>
      events.switchMap(transitionFn);

  @override
  Stream<WorkZoneState> mapEventToState(
    WorkZoneEvent event,
  ) async* {
    print("🙏 $event");
    if (event is SearchWorkZoneAtTime) {
      yield await _handleSelectWorkZoneAtTime(event);
    } else if (event is HighlightWorkZoneOfTime) {
      yield await _handleHighlightedWorkZoneAtTime(event);
    } else if (event is SearchWorkZoneOnDate) {
      yield await _handleSelectWorkZoneAtDate(event);
    } else if (event is SearchWorkZoneAtPeriod) {
      yield await _handleSelectWorkZoneAtPeriod(event);
    }
  }

  Future<WorkZoneState> _handleSelectWorkZoneAtPeriod(
      SearchWorkZoneAtPeriod event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtPeriod(
          event.site, event.date, event.period),
      workZoneMapViewModel.getCameraPositionAtPeriod(
          event.site, event.date, event.period)
    ]);
    return WorkZonePolygons(event.site, result[0], {}, result[1]);
  }

  Future<WorkZoneState> _handleSelectWorkZoneAtDate(
      SearchWorkZoneOnDate event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(event.site, event.date),
      workZoneMapViewModel.getCameraPositionAtDate(event.site, event.date)
    ]);
    return WorkZonePolygons(event.site, result[0], {}, result[1]);
  }

  Future<WorkZoneState> _handleSelectWorkZoneAtTime(
      SearchWorkZoneAtTime event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(
          event.site, event.startTime.startOfDay),
      workZoneMapViewModel.getPolygonAtTime(
          event.site, event.startTime, event.endTime),
      workZoneMapViewModel.getCameraPositionAtTime(
          event.site, event.startTime, event.endTime)
    ]);
    return WorkZonePolygons(event.site, result[0], result[1], result[2]);
  }

  Future<WorkZoneState> _handleHighlightedWorkZoneAtTime(
      HighlightWorkZoneOfTime event) async {
    final newState = await state.siteName?.let((site) => workZoneMapViewModel
        .getPolygonAtTime(site, event.highlightedTimeRange.start,
            event.highlightedTimeRange.end)
        .then((highlight) => WorkZonePolygons(
            site, state.workZone, highlight, state.cameraPosition)));
    return newState ?? state;
  }

  @override
  Future<void> close() {
    _selectedSiteSubscription?.cancel();
    _dailyChartSubscription?.cancel();
    _trendChartSubscription?.cancel();
    return super.close();
  }
}
