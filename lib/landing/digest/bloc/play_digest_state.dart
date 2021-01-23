part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestState extends Equatable {}

/// Pause the playing and show the collage of cover images.
class PlayDigestPausePlaying extends PlayDigestState {
  final List<String> coverImages;

  PlayDigestPausePlaying(this.coverImages);

  @override
  List<Object> get props => [coverImages];
}

/// Indicating the progress of downloading images.
class PlayDigestBuffering extends PlayDigestState {
  @override
  List<Object> get props => [];
}

/// Start animating the next image with previous image as background.
class PlayDigestShowImage extends PlayDigestState {
  final List<String> images;

  PlayDigestShowImage(this.images);

  @override
  List<Object> get props => [images];
}
