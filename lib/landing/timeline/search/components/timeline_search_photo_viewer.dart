import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/bloc/timeline_gallery_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/web/timeline_gallery_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef TapImage(BuildContext context);

/// Display the image for a selected time period and build the annotation and actions.
class TimelineSearchPhotoViewer extends StatelessWidget
    with TimelineImageBuilder, TimelineGalleryViewAccessories {
  final int index;
  final double width;
  final bool? isHighlighted;
  final TapImage? onTapImage;

  TimelineSearchPhotoViewer(this.index,
      {required this.width, this.onTapImage, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (context, state) =>
              state.images
                  .getOrNull<TimelineImageModel>(index)
                  ?.let((image) => Hero(
                      tag: 'image' + image.imageName,
                      child: buildImageCell(
                        image.imageName,
                        context: context,
                        width: width,
                        isHighlighted: isHighlighted,
                        status: image.status,
                        indexLabel: "${index + 1}/${state.images.length}",
                        annotation: image.timeString,
                        actions: buildActions(context, simplified: true),
                        onTap: () => getValueForScreenType<GestureTapCallback>(
                            context: context,
                            mobile: () => _navigateToGallery(context),
                            tablet: () => _navigateToGallery(context),
                            desktop: () => openGalleryDialog(
                                context, state.images, index))(),
                      ))) ??
              Container());

  void _navigateToGallery(BuildContext context) =>
      BlocProvider.of<TimelineSearchBloc>(context)
          .add(TapImageAndNavigateToGallery(index, context));

  void openGalleryDialog(BuildContext context, List<TimelineImageModel> images,
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
