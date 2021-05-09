import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_detail.dart';
import 'package:groundvisual_flutter/models/image_downloading_model.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:groundvisual_flutter/repositories/timeline_images_repository.dart';
import 'package:injectable/injectable.dart';

part 'daily_timeline_event.dart';

part 'daily_timeline_state.dart';

/// Control the logic of displaying the timelapse photos in a day.
@injectable
class DailyTimelineBloc extends Bloc<DailyTimelineEvent, DailyTimelineState> {
  final SelectedSiteBloc? selectedSiteBloc;
  final TimelineImagesRepository timelineImagesRepository;

  StreamSubscription? _selectedSiteSubscription;

  DailyTimelineBloc(
    this.timelineImagesRepository,
    @factoryParam this.selectedSiteBloc,
  ) : super(DailyTimelineLoading()) {
    _listenToSelectedSite();
  }

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc?.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState? state) {
    if (state is SelectedSiteAtDate) {
      add(SearchDailyTimelineOnDate(state.siteName, state.date));
    }
  }

  @override
  Stream<DailyTimelineState> mapEventToState(
    DailyTimelineEvent event,
  ) async* {
    if (event is SearchDailyTimelineOnDate) {
      await Future.delayed(Duration(seconds: 2));
      final images = await timelineImagesRepository.getTimelineImages(
          ["00001A"], DateTimeRange(start: Date.startOfToday, end: Date.today));
      yield DailyTimelineImagesLoaded(images, event.date);
    } else if (event is TapDailyTimelineCell) {
      int initialIndex = state.images.indexWhere(
          (image) => image.downloadingModel.timeRange.start == event.startTime);
      if (initialIndex == -1) {
        return;
      } else {
        _navigateToDetailPage(event.context, state.images, initialIndex);
      }
    }
  }

  @override
  Future<void> close() {
    _selectedSiteSubscription?.cancel();
    return super.close();
  }

  void _navigateToDetailPage(BuildContext context,
          List<TimelineImageModel> images, int initialImageIndex) =>
      FluroRouter.appRouter.navigateTo(
        context,
        '/site/timeline/detail',
        transition: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 500),
        routeSettings: RouteSettings(
          arguments: HeroType(
              title: "3:00 PM ~ 3:15 PM",
              subTitle: "Working",
              images: images,
              initialImageIndex: initialImageIndex,
              materialColor: Theme.of(context).colorScheme.primary),
        ),
      );
}
