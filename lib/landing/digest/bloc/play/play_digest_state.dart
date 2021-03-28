part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestState extends Equatable {}

class PlayDigestInit extends PlayDigestState {
  List<Object> get props => [];
}

/// Pause the playing and show the collage of cover images.
class PlayDigestPausePlaying extends PlayDigestState {
  final List<String> coverImages;
  final String siteName;
  final DateTime date;

  PlayDigestPausePlaying(this.coverImages, this.siteName, this.date);

  @override
  List<Object> get props => [coverImages, siteName, date];
}

/// Indicating the progress of downloading images.
class PlayDigestBuffering extends PlayDigestState {
  @override
  List<Object> get props => [];
}

/// Start animating the next image with previous image as background.
class PlayDigestShowImage extends PlayDigestState {
  final DigestImageModel images;
  final String siteName;
  final DateTime date;

  PlayDigestShowImage(this.images, this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date, images];

  @override
  String toString() => "Site: $siteName; Date: $date; Digest: $images";
}
