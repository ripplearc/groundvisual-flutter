import 'package:flutter/material.dart';

import 'image_resolution.dart';

/// With a [timeRange], the [numberOfImages] from machine [muid] available for
/// downloading at the [resolution].
class ImageDownloadingModel {
  final String muid;
  final DateTimeRange timeRange;
  final int numberOfImages;
  final ImageResolution? resolution;

  ImageDownloadingModel(this.muid,
      {required this.timeRange,
      required this.numberOfImages,
      this.resolution = ImageResolution.I702P});
}
