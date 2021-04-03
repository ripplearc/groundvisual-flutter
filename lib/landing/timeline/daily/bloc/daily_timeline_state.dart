part of 'daily_timeline_bloc.dart';

/// State of the displaying the timelapse photos in a day
abstract class DailyTimelineState extends Equatable {
  const DailyTimelineState();
}

/// Loading the timelapse photos in a day
class DailyTimelineLoading extends DailyTimelineState {
  @override
  List<Object> get props => [];
}

/// Loaded the timelapse photos in a day
class DailyTimelineImagesLoaded extends DailyTimelineState {
  final List<DailyTimelineImageModel> images;

  DailyTimelineImagesLoaded(this.images);

  @override
  List<Object> get props => [images];
}
