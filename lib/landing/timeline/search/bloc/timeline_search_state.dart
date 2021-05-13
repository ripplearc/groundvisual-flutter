part of 'timeline_search_bloc.dart';

@immutable
abstract class TimelineSearchState extends Equatable {
  final List<TimelineImageModel> images;

  TimelineSearchState(this.images);

  @override
  List<Object?> get props => [images];
}

class TimelineSearching extends TimelineSearchState {
  TimelineSearching() : super([]);
}

/// Loaded the timelapse photos in a day
class TimelineSearchResultsLoaded extends TimelineSearchState {
  TimelineSearchResultsLoaded(List<TimelineImageModel> images) : super(images);
}
