import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:injectable/injectable.dart';

part 'selected_site_event.dart';

part 'selected_site_state.dart';

@injectable
class SelectedSiteBloc
    extends Bloc<SelectedSiteDateTimeEvent, SelectedSiteState> {
  CurrentSelectedSite selectedSitePreference;

  SelectedSiteBloc(this.selectedSitePreference)
      : super(
          selectedSitePreference.value().isEmpty
              ? SelectedSiteEmpty()
              : SelectedSiteAtDay(
                  selectedSitePreference.value(),
                  DateTime.now(),
                ),
        );

  @override
  Stream<SelectedSiteState> mapEventToState(
    SelectedSiteDateTimeEvent event,
  ) async* {
    if (event is SiteSelected) {
      selectedSitePreference.setSelectedSite(event.siteName);
      yield SelectedSiteAtDay(event.siteName, DateTime.now());
    } else if (event is DaySelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtDay(siteName, event.day);
    } else if (event is TrendSelected) {
      final siteName = await selectedSitePreference.site().first;
      yield SelectedSiteAtWindow(
          siteName,
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 7)),
            end: DateTime.now(),
          ));
    }
  }
}
