import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'selected_site_event.dart';

part 'selected_site_state.dart';

/// bloc to take events of selecting date or period, and notify listener about the
/// selected date range.
@injectable
class SelectedSiteBloc
    extends Bloc<SelectedSiteDateTimeEvent, SelectedSiteState> {
  final CurrentSelectedSite selectedSitePreference;
  final MachineStatusBloc machineStatusBloc;
  final WorkZoneMapBloc workZoneMapBloc;
  final PlayDigestBloc playDigestBloc;
  final DailyWorkingTimeChartBloc dailyWorkingTimeChartBloc;
  final TrendWorkingTimeChartBloc trendWorkingTimeChartBloc;

  SelectedSiteBloc(
      this.selectedSitePreference,
      this.machineStatusBloc,
      this.workZoneMapBloc,
      this.dailyWorkingTimeChartBloc,
      this.trendWorkingTimeChartBloc,
      this.playDigestBloc)
      : super(
          selectedSitePreference.value().isEmpty
              ? SelectedSiteEmpty()
              : SelectedSiteAtDate(
                  selectedSitePreference.value(),
                  DateTime.now(),
                ),
        );

  @override
  Stream<Transition<SelectedSiteDateTimeEvent, SelectedSiteState>>
      transformEvents(Stream<SelectedSiteDateTimeEvent> events, transitionFn) =>
          events.switchMap((transitionFn));

  @override
  Stream<SelectedSiteState> mapEventToState(
    SelectedSiteDateTimeEvent event,
  ) async* {
    if (event is SelectedSiteInit) {
      final siteName = await selectedSitePreference.site().first;
      _signalOtherBlocsOnInit(siteName, event);
      yield SelectedSiteAtDate(siteName, Date.startOfToday);
    } else if (event is SiteSelected) {
      _signalOtherBlocsOnSiteSelected(event);
      selectedSitePreference.setSelectedSite(event.siteName);
      yield SelectedSiteAtDate(event.siteName, Date.startOfToday);
    } else if (event is DateSelected) {
      final siteName = await selectedSitePreference.site().first;
      _signalOtherBlocsOnDateSelected(siteName, event);
      yield SelectedSiteAtDate(siteName, event.date);
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference.site().first;
      _signalOtherBlocsOnTrendSelected(siteName, event);
      yield SelectedSiteAtTrend(
          siteName,
          DateTimeRange(
              start: Date.endOfToday,
              end: Date.endOfToday
                  .subtract(Duration(days: event.period.days()))),
          event.period);
    }
  }

  void _signalOtherBlocsOnTrendSelected(String siteName, TrendSelected event) {
    machineStatusBloc.add(SearchMachineStatueOnTrend(siteName, event.period));
    workZoneMapBloc.add(SearchWorkZoneAtPeriod(
        siteName, Date.startOfToday, event.period, event.context));
    trendWorkingTimeChartBloc
        .add(SearchWorkingTimeOnTrend(siteName, event.period, event.context));
  }

  void _signalOtherBlocsOnDateSelected(String siteName, DateSelected event) {
    dailyWorkingTimeChartBloc
        .add(SearchWorkingTimeOnDate(siteName, event.date, event.context));
    machineStatusBloc.add(SearchMachineStatusOnDate(siteName, event.date));
    playDigestBloc
        .add(PlayDigestInitPlayer(event.context, siteName, Date.startOfToday));
    workZoneMapBloc
        .add(SearchWorkZoneOnDate(siteName, event.date, event.context));
  }

  void _signalOtherBlocsOnSiteSelected(SiteSelected event) {
    machineStatusBloc
        .add(SearchMachineStatusOnDate(event.siteName, Date.startOfToday));
    workZoneMapBloc.add(
        SearchWorkZoneOnDate(event.siteName, Date.startOfToday, event.context));
    dailyWorkingTimeChartBloc.add(SearchWorkingTimeOnDate(
        event.siteName, Date.startOfToday, event.context));
    playDigestBloc.add(
        PlayDigestInitPlayer(event.context, event.siteName, Date.startOfToday));
  }

  void _signalOtherBlocsOnInit(String siteName, SelectedSiteInit event) {
    machineStatusBloc
        .add(SearchMachineStatusOnDate(siteName, Date.startOfToday));
    workZoneMapBloc
        .add(SearchWorkZoneOnDate(siteName, Date.startOfToday, event.context));
    dailyWorkingTimeChartBloc.add(
        SearchWorkingTimeOnDate(siteName, Date.startOfToday, event.context));
    playDigestBloc
        .add(PlayDigestInitPlayer(event.context, siteName, Date.startOfToday));
  }
}
