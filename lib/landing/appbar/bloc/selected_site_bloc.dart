import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_viewmodel.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/chart/trend/working_time_trend_chart_viewmodel.dart';
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
  CurrentSelectedSite selectedSitePreference;
  MachineStatusBloc machineStatusBloc;
  WorkingTimeDailyChartViewModel workingTimeDailyChartViewModel;
  WorkingTimeTrendChartViewModel workingTimeTrendChartViewModel;

  SelectedSiteBloc(
      this.selectedSitePreference,
      this.workingTimeDailyChartViewModel,
      this.workingTimeTrendChartViewModel,
      this.machineStatusBloc)
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
      machineStatusBloc
          .add(SearchMachineStatusOnDate(siteName, Date.startOfToday));
      await for (var state
          in _yieldDailyWorkingTime(siteName, Date.startOfToday, event.context))
        yield state;
    } else if (event is SiteSelected) {
      machineStatusBloc
          .add(SearchMachineStatusOnDate(event.siteName, Date.startOfToday));
      selectedSitePreference.setSelectedSite(event.siteName);
      await for (var state in _yieldDailyWorkingTime(
          event.siteName, Date.startOfToday, event.context)) yield state;
    } else if (event is DateSelected) {
      final siteName = await selectedSitePreference.site().first;
      machineStatusBloc.add(SearchMachineStatusOnDate(siteName, event.date));
      await for (var state
          in _yieldDailyWorkingTime(siteName, event.date, event.context))
        yield state;
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference.site().first;
      machineStatusBloc.add(SearchMachineStatueOnTrend(siteName, event.period));
      await for (var state in _yieldTrendWorkingTime(siteName, event))
        yield state;
    }
  }

  Stream _yieldTrendWorkingTime(String siteName, TrendSelected event) {
    final trendFuture = Future.value(SelectedSiteAtTrend(
        siteName,
        DateTimeRange(
          start: Date.startOfToday - Duration(days: event.period.toInt()),
          end: Date.startOfToday,
        ),
        event.period));

    final trendWithChartFuture = Future(() async => await Future.delayed(
        Duration(seconds: 2),
        () => workingTimeTrendChartViewModel.trendWorkingTime(
            event.context, event.period)).then((chart) => SelectedSiteAtTrend(
        siteName,
        DateTimeRange(
          start: Date.startOfToday - Duration(days: event.period.toInt()),
          end: Date.startOfToday,
        ),
        event.period,
        chartData: chart)));
    return Stream.fromFutures([trendFuture, trendWithChartFuture]);
  }

  Stream _yieldDailyWorkingTime(
      String siteName, DateTime date, BuildContext context) {
    final dailyFuture = Future.value(SelectedSiteAtDate(siteName, date));
    final dailyWithChartFuture = Future(() async => await Future.delayed(
            Duration(seconds: 2),
            () => workingTimeDailyChartViewModel.dailyWorkingTime(context))
        .then((dailyChart) =>
            SelectedSiteAtDate(siteName, date, chartData: dailyChart)));

    return Stream.fromFutures([dailyFuture, dailyWithChartFuture]);
  }
}
