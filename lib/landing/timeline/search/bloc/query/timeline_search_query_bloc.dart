import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'timeline_search_query_event.dart';

part 'timeline_search_query_state.dart';

@injectable
class TimelineSearchQueryBloc
    extends Bloc<TimelineSearchQueryEvent, TimelineSearchQueryState> {
  TimelineSearchQueryBloc(
      @factoryParam DateTimeRange? dateRange, @factoryParam String? siteName)
      : super(TimelineSearchQueryInitial(
            dateRange ??
                DateTimeRange(start: Date.startOfToday, end: Date.endOfToday),
            siteName ?? "",
            {}));

  @override
  Stream<TimelineSearchQueryState> mapEventToState(
    TimelineSearchQueryEvent event,
  ) async* {
    if (event is UpdateTimelineSearchQueryOfDateTimeRange) {
      yield TimelineSearchQueryUpdate(
          event.range, state.filteredMachines, state.siteName);
    }
  }
}
