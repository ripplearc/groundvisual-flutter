import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:groundvisual_flutter/repositories/machine_detail_repository.dart';
import 'package:groundvisual_flutter/repositories/machine_working_time_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'timeline_search_query_event.dart';

part 'timeline_search_query_state.dart';

/// [TimelineSearchQueryBloc] stores the user search query, enable or disable
/// search criteria as needed.
@injectable
class TimelineSearchQueryBloc
    extends Bloc<TimelineSearchQueryEvent, TimelineSearchQueryState> {
  final CurrentSelectedSite selectedSitePreference;
  final MachineWorkingTimeRepository machineWorkingTimeRepository;
  final MachineDetailRepository machineDetailRepository;

  TimelineSearchQueryBloc(
      this.selectedSitePreference,
      this.machineWorkingTimeRepository,
      this.machineDetailRepository,
      @factoryParam DateTimeRange? dateRange)
      : super(TimelineSearchQueryInitial(
            dateRange ??
                DateTimeRange(start: Date.startOfToday, end: Date.endOfToday),
            "",
            {})) {
    add(UpdateTimelineSearchQueryFilter());
  }

  @override
  Stream<TimelineSearchQueryState> mapEventToState(
    TimelineSearchQueryEvent event,
  ) async* {
    if (event is UpdateTimelineSearchQueryOfDateTimeRange) {
      yield TimelineSearchQueryUpdate(
          event.range, state.filteredMachines, state.siteName);
    } else if (event is UpdateTimelineSearchQueryFilter) {
      final siteName = await selectedSitePreference.site().first;
      final machines = await machineWorkingTimeRepository
          .getMachineWorkingTime(siteName, state.dateTimeRange)
          .asStream()
          .flatMapIterable((value) => Stream.value(value.keys))
          .flatMap((muid) =>
              machineDetailRepository.getMachineDetail(muid).asStream())
          .toList()
          .then<Map<MachineDetail, bool>>((list) =>
              Map.fromIterable(list, key: (e) => e, value: (_) => true));
      yield TimelineSearchQueryInitial(state.dateTimeRange, siteName, machines);
    } else if (event is UpdateTimelineSearchQueryOfSelectedMachines) {
      yield TimelineSearchQueryUpdate(
          state.dateTimeRange, event.filteredMachines, state.siteName);
    }
  }
}
