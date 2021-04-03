part of 'daily_timeline_bloc.dart';

/// State of the displaying the timelapse photos in a day
abstract class DailyTimelineState extends Equatable {
  final List<DailyTimelineImageModel> images;
  final DateTime date;

  const DailyTimelineState(this.images, this.date);

  @override
  List<Object> get props => [images, date];
}

/// Loading the timelapse photos in a day
class DailyTimelineLoading extends DailyTimelineState {
  DailyTimelineLoading() : super([], Date.startOfToday);
}

/// Loaded the timelapse photos in a day
class DailyTimelineImagesLoaded extends DailyTimelineState {
  DailyTimelineImagesLoaded(List<DailyTimelineImageModel> images, DateTime date)
      : super(images, date);
}

/// Navigate to the timeline detail page and start with the image being tapped
class DailyTimelineNavigateToDetailPage extends DailyTimelineState {
  final int initialImageIndex;

  DailyTimelineNavigateToDetailPage(List<DailyTimelineImageModel> images,
      DateTime date, this.initialImageIndex)
      : super(images, date);

  @override
  List<Object> get props => [images, date, initialImageIndex];
}
