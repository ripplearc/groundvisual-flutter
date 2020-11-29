import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  SelectedSiteBloc(this.selectedSitePreference)
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
      transformEvents(Stream<SelectedSiteDateTimeEvent> events, transitionFn) {
    return events.switchMap((transitionFn));
  }

  @override
  Stream<SelectedSiteState> mapEventToState(
    SelectedSiteDateTimeEvent event,
  ) async* {
    if (event is Init) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtDate(siteName, DateTime.now());
      yield await Future.delayed(Duration(seconds: 2),
          () => SelectedSiteAtDate(siteName, DateTime.now(), bars: ["Hello"]));
    } else if (event is SiteSelected) {
      selectedSitePreference.setSelectedSite(event.siteName);
      yield SelectedSiteAtDate(event.siteName, DateTime.now());
      yield await Future.delayed(
          Duration(seconds: 2),
          () => SelectedSiteAtDate(event.siteName, DateTime.now(),
              bars: ["Hello"]));
    } else if (event is DateSelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtDate(siteName, event.day);
      yield await Future.delayed(Duration(seconds: 2),
          () => SelectedSiteAtDate(siteName, event.day, bars: ["Hello"]));
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtWindow(
          siteName,
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 7)),
            end: DateTime.now(),
          ),
          event.period);
    }
  }
}
