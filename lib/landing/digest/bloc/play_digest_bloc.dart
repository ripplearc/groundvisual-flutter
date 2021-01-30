import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'play_digest_event.dart';

part 'play_digest_state.dart';

/// Bloc for playing the digested images with certain interval
@LazySingleton()
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc(this.dailyDigestViewModel, this.dailyWorkingTimeChartBloc,
      this.dailyChartBarConverter)
      : super(PlayDigestInit());
  final DailyDigestViewModel dailyDigestViewModel;
  final DailyWorkingTimeChartBloc dailyWorkingTimeChartBloc;
  final DailyChartBarConverter dailyChartBarConverter;

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
      return Stream.periodic(Duration(seconds: 4))
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
        yield PlayDigestBuffering();

        final digestModel = await dailyDigestViewModel
            .incrementDigestImageCursor(event.siteName, event.date);
        _signalDailyChartBar(digestModel, event);

        yield PlayDigestShowImage(digestModel, event.siteName, event.date);
        _pauseWhenReachTheEnd(digestModel, event);
        return;
      default:
        return;
    }
  }

  void _signalDailyChartBar(
      DigestImageModel digestModel, PlayDigestEvent event) {
    final indices = dailyChartBarConverter.convertToIndices(digestModel.time);
    dailyWorkingTimeChartBloc.add(SelectDailyChartBarRod(
        indices.item1, indices.item2, event.siteName, event.date, event.context,
        showThumbnail: false));
  }

  void _pauseWhenReachTheEnd(DigestImageModel model, PlayDigestEvent event) {
    if (model.currentImage == null && model.nextImage == null) {
      add(PlayDigestPause(event.context, event.siteName, event.date));
    }
  }

  Future<PlayDigestPausePlaying> _getCoverImages(PlayDigestEvent event) =>
      dailyDigestViewModel.coverImages(event.siteName, event.date).then(
          (images) =>
              PlayDigestPausePlaying(images, event.siteName, event.date));
}
