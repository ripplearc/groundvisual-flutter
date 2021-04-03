import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'daily_timeline_detail_event.dart';
part 'daily_timeline_detail_state.dart';

class DailyTimelineDetailBloc extends Bloc<DailyTimelineDetailEvent, DailyTimelineDetailState> {
  DailyTimelineDetailBloc() : super(DailyTimelineDetailInitial());

  @override
  Stream<DailyTimelineDetailState> mapEventToState(
    DailyTimelineDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
