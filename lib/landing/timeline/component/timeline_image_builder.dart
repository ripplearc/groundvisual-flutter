import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';

typedef OnTapTimelineImage(DateTime timestamp);
mixin TimelineImageBuilder {
  Padding buildImageCell(
          String imageName, BuildContext context, double cellWidth,
          {String? annotation,
          OnTapTimelineImage? onTap,
          MachineStatus? status,
          double padding = 0}) =>
      Padding(
          padding: EdgeInsets.all(padding),
          child: GestureDetector(
              onTap: () => onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      _buildImageWithCorner(
                          imageName, cellWidth, padding, context),
                      if (status != null) _buildLabelIfNeeded(status, context)
                    ]),
                    if (annotation != null)
                      Text(annotation,
                          style: Theme.of(context).textTheme.headline6)
                  ])));

  ClipRRect _buildImageWithCorner(String imageName, double cellWidth,
          double padding, BuildContext context) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: cellWidth - 2 * padding,
          height: 120,
          child: Hero(
              tag: "image" + imageName, child: _buildImage(imageName, context)),
        ),
      );

  Widget _buildLabelIfNeeded(MachineStatus status, BuildContext context) =>
      status == MachineStatus.working
          ? Container()
          : Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            status.value().toUpperCase(),
                            style: Theme.of(context).textTheme.button,
                          )))));

  Widget _buildImage(String imageName, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, context);
    else
      return _buildRaster(imageName);
  }

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
}
