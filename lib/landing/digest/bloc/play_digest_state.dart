part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestState extends Equatable {}

class PlayDigestPausePlaying extends PlayDigestState {
  final List<String> coverImages;

  PlayDigestPausePlaying(this.coverImages);

  @override
  List<Object> get props => [coverImages];
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
