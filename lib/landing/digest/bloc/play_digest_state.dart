part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestState extends Equatable {}

class PlayDigestPausePlaying extends PlayDigestState {
  @override
  List<Object> get props => [];
}

class PlayDigestBuffering extends PlayDigestState {
  @override
  List<Object> get props => [];
}

class PlayDigestShowImage extends PlayDigestState {
  final List<String> images;

  PlayDigestShowImage(this.images);

  @override
  List<Object> get props => [images];
}
