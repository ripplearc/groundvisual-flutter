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
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

part 'timeline_search_images_event.dart';

part 'timeline_search_images_state.dart';

/// Take in the search criteria [TimelineSearchImagesEvent] including location, time,
/// machines and etc, search through the [TimelineImagesRepository] and output
/// the results through [TimelineSearchImagesState] containing [TimelineImageModel] imags.
@injectable
class TimelineSearchImagesBloc
    extends Bloc<TimelineSearchImagesEvent, TimelineSearchImagesState> {
  final TimelineImagesRepository timelineImagesRepository;
  final CurrentSelectedSite selectedSitePreference;

  TimelineSearchImagesBloc(
      this.timelineImagesRepository,
      this.selectedSitePreference,
      @factoryParam List<TimelineImageModel>? defaultImages)
      : super(TimelineSearching(defaultImages));

  @override
  Stream<TimelineSearchImagesState> mapEventToState(
    TimelineSearchImagesEvent event,
  ) async* {
    if (event is SearchDailyTimeline) {
      await Future.delayed(Duration(seconds: 0));
      final siteName = selectedSitePreference.value();
      final images = await timelineImagesRepository.getTimelineImagesAtSite(
          siteName,
          ["00001A"],
          DateTimeRange(start: Date.startOfToday, end: Date.today));
      yield TimelineSearchResultsLoaded(siteName, images);
    } else if (event is HighlightImage) {
      yield state.images.getOrNull<TimelineImageModel>(event.index)?.let(
              (image) =>
                  TimelineSearchResultsHighlighted(state.images, image)) ??
          state;
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
