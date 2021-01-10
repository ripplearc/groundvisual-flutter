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
    final position = [
      Offset(1.5, 0),
      Offset(-1.5, 0),
      Offset(0, 1.5),
      Offset(0, -1.5)
    ].elementAt(random.nextInt(4));
    yield PlayDigestShowImage('images/digest/summary_1.jpg', 3, position);
  }
}
