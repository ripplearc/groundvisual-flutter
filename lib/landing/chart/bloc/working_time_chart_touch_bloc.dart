import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'working_time_chart_touch_event.dart';

part 'working_time_chart_touch_state.dart';

/// bloc to take events of touching a bar rod, and emits state of corresponding images.
@injectable
class WorkingTimeChartTouchBloc
    extends Bloc<WorkingTimeChartTouchEvent, WorkingTimeChartTouchState> {
  WorkingTimeChartTouchBloc() : super(WorkingTimeChartTouchInitial());

  @override
  Stream<WorkingTimeChartTouchState> mapEventToState(
    WorkingTimeChartTouchEvent event,
  ) async* {
    if (event is BarRodSelection) {
      yield WokringTimeChartTouchShowThumbnail(event.groupId, event.rodId);
    } else {
      yield WorkingTimeChartTouchInitial();
    }
  }
}
