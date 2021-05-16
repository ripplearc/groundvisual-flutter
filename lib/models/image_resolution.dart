import 'dart:ui';

/// Image resolution available for image downloading.
enum ImageResolution { I4K, I1080p, I702P, I480P, I360P, I240P, Thumbnail }

extension Dimension on ImageResolution {
  Size get size {
    switch (this) {
      case ImageResolution.I4K:
        return Size(3860, 2160);
      case ImageResolution.I1080p:
        return Size(1920, 1080);
      case ImageResolution.I702P:
        return Size(1280, 720);
      case ImageResolution.I480P:
        return Size(720, 480);
      case ImageResolution.I360P:
        return Size(480, 360);
      case ImageResolution.I240P:
        return Size(352, 240);
      case ImageResolution.Thumbnail:
        return Size(240, 180);
    }
  }
}
