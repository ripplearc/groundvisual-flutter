import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:groundvisual_flutter/repositories/timeline_images_repository.dart';
import 'package:groundvisual_flutter/router/routes.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'timeline_search_event.dart';
part 'timeline_search_state.dart';

/// Take in the search criteria [TimelineSearchEvent] including location, time,
/// machines and etc, search through the [TimelineImagesRepository] and output
/// the results through [TimelineSearchState] containing [TimelineImageModel] imags.
@injectable
class TimelineSearchBloc
    extends Bloc<TimelineSearchEvent, TimelineSearchState> {
  final TimelineImagesRepository timelineImagesRepository;
  final CurrentSelectedSite selectedSitePreference;

  TimelineSearchBloc(this.timelineImagesRepository, this.selectedSitePreference,
      @factoryParam List<TimelineImageModel>? defaultImages)
      : super(TimelineSearching(defaultImages));

  @override
  Stream<TimelineSearchState> mapEventToState(
    TimelineSearchEvent event,
  ) async* {
    if (event is SearchDailyTimeline) {
      await Future.delayed(Duration(seconds: 0));
      final siteName = selectedSitePreference.value();
      final images = await timelineImagesRepository.getTimelineImagesAtSite(
          siteName,
          ["00001A"],
          DateTimeRange(start: Date.startOfToday, end: Date.today));
      print("🚀 ${images.length}");
      yield TimelineSearchResultsLoaded(images);
    } else if (event is TapImageAndNavigateToGallery) {
      _navigateToGalleryPage(event.context, event.index);
    }
  }

  void _navigateToGalleryPage(BuildContext context, int initialIndex) =>
      FluroRouter.appRouter.navigateTo(
        context,
        "${Routes.timelineGallery}?initialIndex=$initialIndex",
        transition: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 500),
        routeSettings: RouteSettings(
          arguments: state.images,
        ),
      );
}
