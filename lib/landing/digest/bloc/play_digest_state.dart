part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestState extends Equatable {}

class PlayDigestInitial extends PlayDigestState {
  @override
  List<Object> get props => [];
}

class PlayDigestShowImage extends PlayDigestState {
  final String image;
  final int animationTimeInSeconds;
  final Offset beginPosition;

  PlayDigestShowImage(this.image, this.animationTimeInSeconds, this.beginPosition);

  @override
  List<Object> get props => [image];
}
