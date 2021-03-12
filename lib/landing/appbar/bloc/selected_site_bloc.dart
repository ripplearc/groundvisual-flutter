import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
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

  SelectedSiteBloc(this.selectedSitePreference)
      : super(selectedSitePreference.value().isEmpty
            ? SelectedSiteEmpty()
            : SelectedSiteAtDate(
                selectedSitePreference.value(),
                DateTime.now(),
              ));

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
      yield SelectedSiteAtDate(siteName, Date.startOfToday);
    } else if (event is SiteSelected) {
      selectedSitePreference.setSelectedSite(event.siteName);
      yield SelectedSiteAtDate(event.siteName, Date.startOfToday);
    } else if (event is DateSelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtDate(siteName, event.date);
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtTrend(
          siteName,
          DateTimeRange(
              start:
                  Date.endOfToday.subtract(Duration(days: event.period.days())),
              end: Date.endOfToday),
          event.period);
    }
  }
}
