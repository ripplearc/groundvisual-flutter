import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_gallery/widgets/photo_view_actions.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

typedef TapImage(BuildContext context);

/// Display the image for a selected time period and build the annotation and actions.
class TimelineSearchPhotoViewer extends StatelessWidget
    with TimelineImageBuilder, PhotoViewAccessories {
  final TimelineImageModel image;
  final double width;
  final TapImage? onTapImage;

  TimelineSearchPhotoViewer(this.image, {required this.width, this.onTapImage});

  @override
  Widget build(BuildContext context) => buildImageCell(image.imageName,
      context: context,
      width: width,
      status: image.status,
      annotation: image.timeString,
      actions: buildActions(context, simplified: true),
      onTap: () => onTapImage?.call(context));
}
