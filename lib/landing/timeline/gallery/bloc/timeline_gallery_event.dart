part of 'timeline_gallery_bloc.dart';

@immutable
abstract class TimelineGalleryEvent extends Equatable {}

/// Loading images of [TimelineImageModel], and convert to consumable by the Gallery.
class LoadingImagesToGallery extends TimelineGalleryEvent {
  final List<TimelineImageModel> images;

  LoadingImagesToGallery(this.images);

  @override
  List<Object?> get props => [images];
}
