import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'play_digest_event.dart';

part 'play_digest_state.dart';

@injectable
class PlayDigestBloc extends Bloc<PlayDigestEvent, PlayDigestState> {
  PlayDigestBloc() : super(PlayDigestInitial());
  final Random random = Random();

  @override
  Stream<PlayDigestState> mapEventToState(
    PlayDigestEvent event,
  ) async* {
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
        ['images/digest/summary_2.jpg', 'images/digest/summary_1.jpg']);
  }
}
