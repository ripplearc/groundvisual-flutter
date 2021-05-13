part of 'timeline_gallery_bloc.dart';

@immutable
abstract class TimelineGalleryState extends Equatable {
  final List<GalleryItem> galleryItems;

  TimelineGalleryState(this.galleryItems);
}

class TimelineGalleryImages extends TimelineGalleryState {
  TimelineGalleryImages(List<GalleryItem> images) : super(images);

  @override
  List<Object?> get props => [galleryItems];
}
