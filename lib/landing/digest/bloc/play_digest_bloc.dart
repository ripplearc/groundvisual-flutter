import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'play_digest_event.dart';

part 'play_digest_state.dart';

@injectable
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc(this.dailyDigestViewModel) : super(PlayDigestPausePlaying([]));
  final DailyDigestViewModel dailyDigestViewModel;
  final Random random = Random();

  @override
  Stream<Transition<PlayDigestEvent, PlayDigestState>> transformEvents(
          Stream<PlayDigestEvent> events, transitionFn) =>
      events.switchMap((transitionFn));

  @override
  Stream<PlayDigestState> mapEventToState(
    PlayDigestEvent event,
  ) async* {
    switch (event.runtimeType) {
      case PlayDigestInitPlayer:
      case PlayDigestPause:
        yield await _getCoverImages();
        return;

      case PlayDigestResume:
        yield PlayDigestBuffering();
        await Future.delayed(Duration(seconds: 4));
        await for (var images in dailyDigestViewModel
            .getDigestPrevAndCurrentImagesWithTimeInterval(4))
          yield PlayDigestShowImage(images);

        yield await _getCoverImages();
        return;
    }
  }

  Future<PlayDigestPausePlaying> _getCoverImages() => dailyDigestViewModel
      .getCoverImages()
      .then((images) => PlayDigestPausePlaying(images));
}
