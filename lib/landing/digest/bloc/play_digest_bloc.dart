import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'play_digest_event.dart';

part 'play_digest_state.dart';

@injectable
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc() : super(PlayDigestPausePlaying([]));
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
        yield PlayDigestPausePlaying(List.generate(
            5, (index) => 'images/digest/summary_${index + 1}.jpg'));
        return;
      case PlayDigestPause:
        yield PlayDigestPausePlaying(List.generate(
            5, (index) => 'images/digest/summary_${index + 1}.jpg'));
        return;
      case PlayDigestResume:
        yield PlayDigestBuffering();
        await Future.delayed(Duration(seconds: 2));
        yield PlayDigestShowImage(['images/digest/summary_1.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage(
            ['images/digest/summary_2.jpg', 'images/digest/summary_1.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage(
            ['images/digest/summary_3.jpg', 'images/digest/summary_2.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage(
            ['images/digest/summary_4.jpg', 'images/digest/summary_3.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage(
            ['images/digest/summary_5.jpg', 'images/digest/summary_4.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage(
            ['images/digest/summary_2.jpg', 'images/digest/summary_5.jpg']);
        await Future.delayed(Duration(seconds: 4));
        yield PlayDigestShowImage([]);
        yield PlayDigestPausePlaying(List.generate(
            5, (index) => 'images/digest/summary_${index + 1}.jpg'));
        return;
    }
  }
}
