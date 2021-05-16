part of 'timeline_gallery_bloc.dart';

@immutable
abstract class TimelineGalleryState extends Equatable {
  final List<GalleryItem> galleryItems;

  TimelineGalleryState(this.galleryItems);
}

/// Emit images of [GalleryItem] to be displayed in the gallery.
class TimelineGalleryLoaded extends TimelineGalleryState {
  TimelineGalleryLoaded(List<GalleryItem> images) : super(images);

  @override
  List<Object?> get props => [galleryItems];
}
