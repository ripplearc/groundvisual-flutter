import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend/trend_working_time_chart_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dart_date/dart_date.dart';

import 'work_zone_map_viewmodel.dart';

part 'work_zone_map_event.dart';

part 'work_zone_map_state.dart';

/// Bloc to control the the WorkZone widget.
/// Both SelectedSiteBloc and WorkingTimeChartTouchBloc signal events to WorkZoneMapBloc.
class WorkZoneMapBloc extends Bloc<WorkZoneMapEvent, WorkZoneMapState> {
  final WorkZoneMapViewModel workZoneMapViewModel;
  final DailyWorkingTimeChartBloc dailyWorkingTimeChartBloc;
  final TrendWorkingTimeChartBloc trendWorkingTimeChartBloc;
  final SelectedSiteBloc selectedSiteBloc;
  StreamSubscription _dailyChartSubscription;
  StreamSubscription _trendChartSubscription;
  StreamSubscription _selectedSiteSubscription;

  WorkZoneMapBloc(this.workZoneMapViewModel,
      {this.selectedSiteBloc,
      this.dailyWorkingTimeChartBloc,
      this.trendWorkingTimeChartBloc})
      : super(WorkZoneMapInitial()) {
    _listenToSelectedSite();
    _listenToDailyChartSelection();
    _listenToTrendChartSelection();
  }

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc.state);
    _selectedSiteSubscription = selectedSiteBloc?.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState state) {
    if (state is SelectedSiteAtDate) {
      add(SearchWorkZoneOnDate(state.siteName, state.date));
    } else if (state is SelectedSiteAtTrend) {
      add(SearchWorkZoneAtPeriod(
          state.siteName, Date.startOfToday, state.period));
    }
  }

  void _listenToTrendChartSelection() {
    _trendChartSubscription = trendWorkingTimeChartBloc?.listen((state) {
      if (state is TrendWorkingTimeBarRodHighlighted) {
        add(SearchWorkZoneOnDate(state.siteName, state.time));
      }
    });
  }

  void _listenToDailyChartSelection() {
    _dailyChartSubscription = dailyWorkingTimeChartBloc?.listen((state) {
      if (state is DailyWorkingTimeBarRodHighlighted) {
        if (state.unselected) {
          add(SearchWorkZoneOnDate(state.siteName, state.time.startOfDay));
        } else {
          add(SearchWorkZoneAtTime(state.siteName, state.time));
        }
      }
    });
  }

  @override
  Stream<Transition<WorkZoneMapEvent, WorkZoneMapState>> transformEvents(
          Stream<WorkZoneMapEvent> events, transitionFn) =>
      events.switchMap(transitionFn);

  @override
  Stream<WorkZoneMapState> mapEventToState(
    WorkZoneMapEvent event,
  ) async* {
    if (event is SearchWorkZoneAtTime) {
      yield await _handleSelectWorkZoneAtTime(event);
    } else if (event is SearchWorkZoneOnDate) {
      yield await _handleSelectWorkZoneAtDate(event);
    } else if (event is SearchWorkZoneAtPeriod) {
      yield await _handleSelectWorkZoneAtPeriod(event);
    }
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtPeriod(
      SearchWorkZoneAtPeriod event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtPeriod(
          event.site, event.date, event.period),
      workZoneMapViewModel.getCameraPositionAtPeriod(
          event.site, event.date, event.period)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtDate(
      SearchWorkZoneOnDate event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtDate(event.site, event.date),
      workZoneMapViewModel.getCameraPositionAtDate(event.site, event.date)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  Future<WorkZoneMapState> _handleSelectWorkZoneAtTime(
      SearchWorkZoneAtTime event) async {
    List<dynamic> result = await Future.wait<dynamic>([
      workZoneMapViewModel.getPolygonAtTime(event.site, event.time),
      workZoneMapViewModel.getCameraPositionAtTime(event.site, event.time)
    ]);
    return WorkZoneMapPolygons(result[0], result[1]);
  }

  @override
  Future<void> close() {
    _selectedSiteSubscription.cancel();
    _dailyChartSubscription.cancel();
    _trendChartSubscription.cancel();
    return super.close();
  }
}
