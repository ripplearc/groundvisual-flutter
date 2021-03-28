import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:injectable/injectable.dart';

part 'daily_timeline_event.dart';
part 'daily_timeline_state.dart';

/// Control the logic of displaying the timelapse photos in a day.
@injectable
class DailyTimelineBloc extends Bloc<DailyTimelineEvent, DailyTimelineState> {
  final SelectedSiteBloc selectedSiteBloc;

  StreamSubscription _selectedSiteSubscription;

  DailyTimelineBloc(@factoryParam this.selectedSiteBloc)
      : super(DailyTimelineLoading()) {
    _listenToSelectedSite();
  }

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc?.state);
    _selectedSiteSubscription = selectedSiteBloc?.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState state) {
    if (state is SelectedSiteAtDate) {
      add(SearchDailyTimelineOnDate(state.siteName, state.date));
    }
  }

  @override
  Stream<DailyTimelineState> mapEventToState(
    DailyTimelineEvent event,
  ) async* {
    await Future.delayed(Duration(seconds: 2));
    if (event is SearchDailyTimelineOnDate) {
      yield DailyTimelineImagesLoaded(List.generate(
          50,
          (index) => DailyTimelineImageModel(
              'images/thumbnails/${index + 1}.jpg',
              Date.startOfToday.add(Duration(minutes: index * 15)),
              Date.startOfToday.add(Duration(minutes: index * 15 + 15)),
              MachineStatus.working)));
    }
  }

  @override
  Future<void> close() {
    _selectedSiteSubscription.cancel();
    return super.close();
  }
}
