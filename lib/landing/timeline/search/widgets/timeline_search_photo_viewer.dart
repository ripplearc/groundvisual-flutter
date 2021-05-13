import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/mobile/timeline_gallery_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/web/timeline_gallery_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef TapImage(BuildContext context);

/// Display the image for a selected time period and build the annotation and actions.
class TimelineSearchPhotoViewer extends StatelessWidget
    with TimelineImageBuilder, TimelineGalleryViewAccessories {
  final int index;
  final double width;
  final TapImage? onTapImage;

  TimelineSearchPhotoViewer(this.index, {required this.width, this.onTapImage});

  @override
  Widget build(BuildContext context) => BlocBuilder<TimelineSearchBloc,
          TimelineSearchState>(
      builder: (context, state) =>
          state.images.getOrNull<TimelineImageModel>(index)?.let((image) =>
              buildImageCell(
                image.imageName,
                context: context,
                width: width,
                status: image.status,
                annotation: image.timeString,
                actions: buildActions(context, simplified: true),
                onTap: () => getValueForScreenType<GestureTapCallback>(
                    context: context,
                    // mobile: () => open(context, state.images, index),
                    mobile: () => BlocProvider.of<TimelineSearchBloc>(context)
                        .add(TapImageAndNavigateToGallery(index, context)),
                    tablet: () => open(context, state.images, index),
                    desktop: () => openDialog(context, state.images, index))(),
              )) ??
          Container());

  void open(
      BuildContext context, List<TimelineImageModel> images, final int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TimelineGalleryMobileView(initialIndex: index)));
  }

  void openDialog(BuildContext context, List<TimelineImageModel> images,
          final int index) =>
      showDialog(
          context: context,
          builder: (_) => SimpleDialog(
              backgroundColor: Colors.transparent,
              children: [TimelineGalleryWebView(initialIndex: index)]));
}
