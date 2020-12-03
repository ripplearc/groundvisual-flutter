import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/landing/chart/viewmodel/working_time_daily_chart_viewmodel.dart';
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
  WorkingTimeDailyChartViewModel workingTimeDailyChartViewModel;

  SelectedSiteBloc(this.selectedSitePreference,
      this.workingTimeDailyChartViewModel)
      : super(
    selectedSitePreference
        .value()
        .isEmpty
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
      SelectedSiteDateTimeEvent event,) async* {
    if (event is Init) {
      final siteName = await selectedSitePreference
          .site()
          .first;
      await for (var emission
      in _yieldDailyWorkingTime(siteName, DateTime.now(), event.context))
        yield emission;
    } else if (event is SiteSelected) {
      selectedSitePreference.setSelectedSite(event.siteName);
      await for (var emission in _yieldDailyWorkingTime(
          event.siteName, DateTime.now(), event.context))
        yield emission;
    } else if (event is DateSelected) {
      final siteName = await selectedSitePreference
          .site()
          .first;
      await for (var emission
      in _yieldDailyWorkingTime(siteName, event.day, event.context))
        yield emission;
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference
          .site()
          .first;
      yield SelectedSiteAtWindow(
          siteName,
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 7)),
            end: DateTime.now(),
          ),
          event.period);
    }
  }

  Stream _yieldDailyWorkingTime(String siteName, DateTime date,
      BuildContext context) async* {
    yield SelectedSiteAtDate(siteName, date);
    var dailyChart = await Future.delayed(Duration(seconds: 2),
            () => workingTimeDailyChartViewModel.dailyWorkingTime(context));
    yield SelectedSiteAtDate(siteName, date, dailyChart: dailyChart);
  }
}
