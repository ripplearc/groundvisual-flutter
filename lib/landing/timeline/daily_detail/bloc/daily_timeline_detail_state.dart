part of 'daily_timeline_detail_bloc.dart';

@immutable
abstract class TimelineSearchState extends Equatable {
  final List<TimelineImageModel> images;

  TimelineSearchState(this.images);

  @override
  List<Object?> get props => [images];
}

class DailyTimelineDetailLoading extends TimelineSearchState {
  DailyTimelineDetailLoading() : super([]);
}

/// Loaded the timelapse photos in a day
class DailyTimelineDetailImagesLoaded extends TimelineSearchState {
  DailyTimelineDetailImagesLoaded(List<TimelineImageModel> images)
      : super(images);
}
