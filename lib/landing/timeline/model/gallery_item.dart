/// Model for displaying in the gallery.
class GalleryItem {
  GalleryItem(
      {required this.tag,
      required this.resource,
      this.isSvg = false,
      this.statusLabel = ""});

  final String tag;
  final String resource;
  final bool isSvg;
  final String statusLabel;
}
