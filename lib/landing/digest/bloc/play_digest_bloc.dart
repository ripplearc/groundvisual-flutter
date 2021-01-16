import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'play_digest_event.dart';
part 'play_digest_state.dart';

/// Bloc for playing the digested images with certain interval
@injectable
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc(this.dailyDigestViewModel) : super(PlayDigestPausePlaying([]));
  final DailyDigestViewModel dailyDigestViewModel;

  @override
  Stream<Transition<PlayDigestEvent, PlayDigestState>> transformEvents(
          Stream<PlayDigestEvent> events, transitionFn) =>
      events
          .switchMap<PlayDigestEvent>(
              (event) => _playDigestImagePeriodicallyAfterResume(event))
          .switchMap((transitionFn));

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
      case PlayDigestPause:
        yield await _getCoverImages();
        return;
      case PlayDigestResume:
        yield PlayDigestBuffering();
        await Future.delayed(Duration(milliseconds: 50));
        final images = await dailyDigestViewModel
            .incrementCurrentDigestImageCursor();
        yield PlayDigestShowImage(images);
        _pauseWhenReachTheEnd(images);
        return;
      default:
        return;
    }
  }

  void _pauseWhenReachTheEnd(List<String> images) {
    if (images.length == 0) {
      add(PlayDigestPause());
    }
  }

  Future<PlayDigestPausePlaying> _getCoverImages() =>
      dailyDigestViewModel.coverImages
          .then((images) => PlayDigestPausePlaying(images));
}
