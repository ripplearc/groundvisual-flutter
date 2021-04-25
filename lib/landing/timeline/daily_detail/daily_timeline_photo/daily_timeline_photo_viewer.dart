import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_gallery/widgets/photo_view_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';

typedef TapImage(BuildContext context, int index);

class DailyTimelinePhotoViewer extends StatelessWidget
    with TimelineImageBuilder, PhotoViewAccessories {
  final DailyTimelineImageModel image;
  final int index;
  final double width;
  final TapImage? onTapImage;

  DailyTimelinePhotoViewer(this.image,
      {required this.index, required this.width, this.onTapImage});

  @override
  Widget build(BuildContext context) => buildImageCell(image.imageName,
      context: context,
      width: width,
      status: image.status,
      annotation: "3:00 ~ 3:15",
      actions: buildActions(context, simplified: true),
      onTap: () => onTapImage?.call(context, index));
}
