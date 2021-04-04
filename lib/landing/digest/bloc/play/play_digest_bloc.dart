import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play/daily_digest_viewmodel.dart';
import 'package:groundvisual_flutter/landing/digest/model/digest_image_model.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'play_digest_event.dart';

part 'play_digest_state.dart';

/// Bloc for playing the digested images with certain interval
@injectable
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc(this.dailyDigestViewModel, @factoryParam this.selectedSiteBloc)
      : super(PlayDigestInit()) {
    _listenToSelectedSite();
  }

  final DailyDigestViewModel dailyDigestViewModel;

  final SelectedSiteBloc selectedSiteBloc;
  StreamSubscription _selectedSiteSubscription;
  static const int SlideAnimationSpeed = 4;

  void _listenToSelectedSite() {
    _processSelectedSiteState(selectedSiteBloc.state);
    _selectedSiteSubscription = selectedSiteBloc?.stream?.listen((state) {
      _processSelectedSiteState(state);
    });
  }

  void _processSelectedSiteState(SelectedSiteState state) {
    if (state is SelectedSiteAtDate) {
      add(PlayDigestInitPlayer(state.siteName, Date.startOfToday));
    } else if (state is SelectedSiteAtTrend) {
      add(PlayDigestInitPlayer(state.siteName, Date.startOfToday));
    }
  }

  @override
  Stream<Transition<PlayDigestEvent, PlayDigestState>> transformEvents(
          Stream<PlayDigestEvent> events, transitionFn) =>
      events.switchMap((event) => _playDigestImagePeriodicallyAfterResume(event)
          .switchMap(transitionFn));

  Stream<PlayDigestEvent> _playDigestImagePeriodicallyAfterResume(
      PlayDigestEvent event) {
    if (event is PlayDigestPause || event is PlayDigestInitPlayer) {
      return Stream.value(event);
    } else if (event is PlayDigestResume) {
      return Stream.periodic(Duration(seconds: SlideAnimationSpeed))
          .startWith(null)
          .map((__) => event);
    } else {
      return Stream.empty();
    }
  }

  @override
  Stream<PlayDigestState> mapEventToState(PlayDigestEvent event) async* {
    switch (event.runtimeType) {
      case PlayDigestInitPlayer:
        await dailyDigestViewModel.preloadImages(event.siteName, event.date);
        yield await _getCoverImages(event);
        return;
      case PlayDigestPause:
        yield await _getCoverImages(event);
        return;
      case PlayDigestResume:
        await for (var state in _resumeOrRewind(event)) yield state;
        return;
      default:
        return;
    }
  }

  Stream<PlayDigestState> _resumeOrRewind(PlayDigestEvent event) async* {
    if (dailyDigestViewModel.shouldRewind()) {
      final emptyImage = DigestImageModel(null, null, event.date.startOfDay);
      yield PlayDigestShowImage(emptyImage, event.siteName, event.date);
      _signalDailyChartBar(emptyImage, event);
      add(PlayDigestPause(event.siteName, event.date));
    } else {
      yield PlayDigestBuffering();
      final digestModel =
          await dailyDigestViewModel.fetchNextImage(event.siteName, event.date);
      _signalDailyChartBar(digestModel, event);
      yield PlayDigestShowImage(digestModel, event.siteName, event.date);
    }
  }

  void _signalDailyChartBar(
      DigestImageModel digestModel, PlayDigestEvent event) {}

  Future<PlayDigestPausePlaying> _getCoverImages(PlayDigestEvent event) =>
      dailyDigestViewModel.coverImages(event.siteName, event.date).then(
          (images) =>
              PlayDigestPausePlaying(images, event.siteName, event.date));

  @override
  Future<void> close() {
    _selectedSiteSubscription.cancel();
    return super.close();
  }
}
