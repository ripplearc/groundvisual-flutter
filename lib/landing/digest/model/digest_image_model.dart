/// Display model for digest slide show.
class DigestImageModel {
  final String currentImage;
  final String nextImage;
  final DateTime time;

  DigestImageModel(this.currentImage, this.nextImage, this.time);

  @override
  String toString() =>
      "CurrentImage: $currentImage; NextImage: $nextImage; Time: $time";
}
