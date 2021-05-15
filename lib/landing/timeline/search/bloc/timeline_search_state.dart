part of 'timeline_search_bloc.dart';

@immutable
abstract class TimelineSearchState extends Equatable {
  final List<TimelineImageModel> images;

  TimelineSearchState(this.images);

  @override
  List<Object?> get props => [images];
}

/// Searching for images of [TimelineImageModel] that matches query of [SearchDailyTimeline].
/// It emits [defaultImages] at the beginning.
class TimelineSearching extends TimelineSearchState {
  TimelineSearching(List<TimelineImageModel>? defaultImages)
      : super(defaultImages ?? []);
}

/// Emit images of [TimelineImageModel] after the search query returns.
class TimelineSearchResultsLoaded extends TimelineSearchState {
  TimelineSearchResultsLoaded(List<TimelineImageModel> images) : super(images);
}
