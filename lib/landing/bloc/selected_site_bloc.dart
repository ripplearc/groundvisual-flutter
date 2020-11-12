import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/repositories/CurrentSelectedSite.dart';
import 'package:injectable/injectable.dart';

part 'selected_site_event.dart';

part 'selected_site_state.dart';

@injectable
class SelectedSiteBloc extends Bloc<SelectedSiteEvent, SelectedSiteState> {
  CurrentSelectedSite selectedSitePreference;

  SelectedSiteBloc(this.selectedSitePreference)
      : super(selectedSitePreference.value().isEmpty
            ? SelectedSiteEmpty()
            : SelectedSiteName(selectedSitePreference.value()));

  @override
  Stream<SelectedSiteState> mapEventToState(
    SelectedSiteEvent event,
  ) async* {
    if (event is SiteSelected) {
      selectedSitePreference.setSelectedSite(event.siteName);
      yield SelectedSiteName(event.siteName);
    }
  }
}
