/// Model for displaying in the gallery.
class GalleryItem {
  GalleryItem(
      {required this.tag,
      required this.imageName,
      this.isSvg = false,
      this.statusLabel = ""});

  final String tag;
  final String imageName;
  final bool isSvg;
  final String statusLabel;
}
