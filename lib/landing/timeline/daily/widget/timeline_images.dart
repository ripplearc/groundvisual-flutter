import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/bloc/daily_timeline_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:shimmer/shimmer.dart';

/// Display the timelapse images with its timestamp.
class TimelineImages extends StatelessWidget with TimelineImageBuilder {
  final ScrollController? scrollController;
  final Size cellSize;
  final List<DailyTimelineImageModel> images;
  final double padding = 8;

  const TimelineImages(
      {Key? key,
      required this.cellSize,
      required this.images,
      this.scrollController})
      : super(key: key);

  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _buildShimmerCell(context);
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) => ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (_, index) => images.elementAt(index).let((image) => Hero(
          tag: "image" + image.imageName,
          child: buildImageCell(image.imageName,
              context: context,
              width: cellSize.width,
              annotation: image.timeString,
              actions: [], onTap: () {
            BlocProvider.of<DailyTimelineBloc>(context)
                .add(TapDailyTimelineCell(image.startTime));
          }, status: image.status, padding: padding))));

  Padding _buildShimmerCell(BuildContext context) => Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surface,
                    highlightColor: Theme.of(context).colorScheme.onSurface,
                    child: Container(
                        width: cellSize.width - 2 * padding,
                        height: cellSize.height,
                        color: Theme.of(context).colorScheme.background))),
            Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.onSurface,
                child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                        width: 80,
                        height: 20,
                        color: Theme.of(context).colorScheme.background)))
          ]));
}
