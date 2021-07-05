part of 'timeline_search_images_bloc.dart';

@immutable
abstract class TimelineSearchImagesState extends Equatable {
  final List<TimelineImageModel> images;
  // final Set<Polygon> workZone;
  // final CameraPosition? cameraPosition;

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
  TimelineSearchResultsLoaded(List<TimelineImageModel> images) : super(images);
}
