import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:shimmer/shimmer.dart';

/// Display the timelapse images with its timestamp.
class TimelineImages extends StatelessWidget {
  final ScrollController scrollController;
  final double cellWidth;
  final List<DailyTimelineImageModel> images;
  final double padding = 8;

  const TimelineImages(
      {Key key, this.scrollController, this.cellWidth, this.images})
      : super(key: key);

  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _buildShimmerCell(context);
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) => Expanded(
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (_, index) {
            if (index == 0)
              return _buildImageCell('assets/icon/excavator.svg',
                  '$index:00 ~ $index:15', context);
            else
              return _buildImageCell(images[index].imageName,
                  _buildAnnotation(images[index]), context);
          }));

  Padding _buildImageCell(
          String imageName, String annotation, BuildContext context) =>
      Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                      width: cellWidth - 2 * padding,
                      height: 120,
                      child: _buildImage(imageName, context)),
                ),
                Text(annotation, style: Theme.of(context).textTheme.headline6)
              ]));

  Widget _buildImage(String imageName, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, context);
    else
      return _buildRaster(imageName);
  }

  String _buildAnnotation(DailyTimelineImageModel image) =>
      [image.startTime, image.endTime]
          .map((time) =>
              time.hour.toString() +
              (time.minute == 0 ? ":0" : ":") +
              time.minute.toString())
          .reduce((value, element) => value + " ~ " + element);

  SvgPicture _buildSvg(String imageName, BuildContext context) =>
      SvgPicture.asset(
        imageName,
        color: Theme.of(context).colorScheme.primary,
        fit: BoxFit.contain,
      );

  Image _buildRaster(String imageName) => Image.asset(
        imageName,
        fit: BoxFit.contain,
      );

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
                        width: cellWidth - 2 * padding,
                        height: 120,
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
