import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/bloc/timeline_gallery_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/web/timeline_gallery_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef TapImage(BuildContext context);

/// Display the [image] and its associated annoations and actions for a selected time period.
class TimelineSearchImageBuilder
    with TimelineImageBuilder, TimelineGalleryViewAccessories {
  final TimelineImageModel image;
  final List<TimelineImageModel> images;
  final int index;
  final double width;
  final bool? isHighlighted;
  final TapImage? onTapImage;
  final bool? enableHeroAnimation;

  TimelineSearchImageBuilder(this.image,
      {required this.width,
      required this.index,
      required this.images,
      this.onTapImage,
      this.isHighlighted = false,
      this.enableHeroAnimation = false});

  List<Widget> buildSearchImageCellWidgets(BuildContext context) =>
      buildImageCellWidgets(
        image.imageName,
        context: context,
        width: width,
        isHighlighted: isHighlighted,
        status: image.status,
        annotation: image.timeString,
        heroAnimationTag: enableHeroAnimation == true
            ? 'image' + image.imageName
            : 'no animation' + image.imageName,
        actions: buildActions(context, simplified: true),
        onTap: () => getValueForScreenType<GestureTapCallback>(
            context: context,
            mobile: () => _navigateToGallery(context),
            tablet: () => _navigateToGallery(context),
            desktop: () => _openGalleryDialog(context, images, index))(),
      );

  void _navigateToGallery(BuildContext context) =>
      BlocProvider.of<TimelineSearchBloc>(context)
          .add(TapImageAndNavigateToGallery(index, context));

  void _openGalleryDialog(BuildContext context, List<TimelineImageModel> images,
          final int index) =>
      showDialog(
          context: context,
          builder: (_) =>
              SimpleDialog(backgroundColor: Colors.transparent, children: [
                BlocProvider(
                    create: (context) =>
                        getIt<TimelineGalleryBloc>(param1: images),
                    child: TimelineGalleryWebView(initialIndex: index)),
              ]));
}
