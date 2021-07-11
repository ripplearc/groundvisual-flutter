part of 'timeline_search_images_bloc.dart';

@immutable
abstract class TimelineSearchImagesState extends Equatable {
  final List<TimelineImageModel> images;

  TimelineSearchImagesState(this.images);

  @override
  List<Object?> get props => [images];
}

/// Searching for images of [TimelineImageModel] that matches query of [SearchDailyTimeline].
/// It emits [defaultImages] at the beginning.
class TimelineSearching extends TimelineSearchImagesState {
  TimelineSearching(List<TimelineImageModel>? defaultImages)
      : super(defaultImages ?? []);
}

/// Emit images of [TimelineImageModel] after the search query returns.
class TimelineSearchResultsLoaded extends TimelineSearchImagesState {
  final String siteName;

  TimelineSearchResultsLoaded(this.siteName, List<TimelineImageModel> images)
      : super(images);

  @override
  List<Object?> get props => [images, siteName];
}

/// Highlight an image of [TimelineImageModel] among the search query returns.
class TimelineSearchResultsHighlighted extends TimelineSearchImagesState {
  final TimelineImageModel highlightedImage;

  TimelineSearchResultsHighlighted(
      List<TimelineImageModel> images, this.highlightedImage)
      : super(images);

  @override
  List<Object?> get props => [highlightedImage];
}
