part of 'timeline_gallery_bloc.dart';

@immutable
abstract class TimelineGalleryEvent extends Equatable {}

class LoadingImagesToGallery extends TimelineGalleryEvent {
  final List<TimelineImageModel> images;

  LoadingImagesToGallery(this.images);

  @override
  List<Object?> get props => [images];
}
