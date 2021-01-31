part of 'play_digest_bloc.dart';

@immutable
abstract class PlayDigestEvent extends Equatable {
  final BuildContext context;

  final String siteName;
  final DateTime date;

  PlayDigestEvent(this.context, this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date];
}

/// Resume playing the daily activity digest.
class PlayDigestResume extends PlayDigestEvent {
  PlayDigestResume(BuildContext context, String site, DateTime date)
      : super(context, site, date);
}

/// Pause playing the daily activity digest.
class PlayDigestPause extends PlayDigestEvent {
  PlayDigestPause(BuildContext context, String site, DateTime date)
      : super(context, site, date);
}

/// Initialize the digest widget, and load the cover images.
class PlayDigestInitPlayer extends PlayDigestEvent {
  PlayDigestInitPlayer(BuildContext context, String site, DateTime date)
      : super(context, site, date);
}
