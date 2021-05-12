import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:groundvisual_flutter/repositories/timeline_images_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'timeline_search_event.dart';

part 'timeline_search_state.dart';

@injectable
class TimelineSearchBloc
    extends Bloc<TimelineSearchEvent, TimelineSearchState> {
  final TimelineImagesRepository timelineImagesRepository;

  TimelineSearchBloc(this.timelineImagesRepository)
      : super(TimelineSearching());

  @override
  Stream<TimelineSearchState> mapEventToState(
    TimelineSearchEvent event,
  ) async* {
    if (event is SearchDailyTimeline) {
      await Future.delayed(Duration(seconds: 0));
      final images = await timelineImagesRepository.getTimelineImagesAtSite(
          event.siteName,
          ["00001A"],
          DateTimeRange(start: Date.startOfToday, end: Date.today));
      yield TimelineSearchResultsLoaded(images);
    }
  }
}
