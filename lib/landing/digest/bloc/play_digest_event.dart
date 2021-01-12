part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestEvent extends Equatable {}

class PlayDigestResume extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}

class PlayDigestPause extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}

class PlayDigestInitPlayer extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}
