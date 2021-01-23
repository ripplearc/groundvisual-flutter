part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestEvent extends Equatable {}

/// Resume playing the daily activity digest.
class PlayDigestResume extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}

/// Pause playing the daily activity digest.
class PlayDigestPause extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}

/// Initialize the digest widget.
class PlayDigestInitPlayer extends PlayDigestEvent {
  @override
  List<Object> get props => [];
}
