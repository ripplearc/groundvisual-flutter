part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestEvent extends Equatable {

  final String siteName;
  final DateTime date;

  PlayDigestEvent( this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date];
}

/// Resume playing the daily activity digest.
class PlayDigestResume extends PlayDigestEvent {
  PlayDigestResume( String site, DateTime date)
      : super(site, date);
}

/// Pause playing the daily activity digest.
class PlayDigestPause extends PlayDigestEvent {
  PlayDigestPause( String site, DateTime date)
      : super(site, date);
}

/// Initialize the digest widget, and load the cover images.
class PlayDigestInitPlayer extends PlayDigestEvent {
  PlayDigestInitPlayer( String site, DateTime date)
      : super(site, date);
}
