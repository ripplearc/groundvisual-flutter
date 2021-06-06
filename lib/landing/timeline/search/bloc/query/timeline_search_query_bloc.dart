import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/extensions/date.dart';

part 'timeline_search_query_event.dart';

part 'timeline_search_query_state.dart';

@injectable
class TimelineSearchQueryBloc
    extends Bloc<TimelineSearchQueryEvent, TimelineSearchQueryState> {
  TimelineSearchQueryBloc(
      @factoryParam DateTime? startDate, @factoryParam DateTime? endDate)
      : super(TimelineSearchQueryInitial(
            startDate ?? Date.startOfToday, endDate ?? Date.endOfToday));

  @override
  Stream<TimelineSearchQueryState> mapEventToState(
    TimelineSearchQueryEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
