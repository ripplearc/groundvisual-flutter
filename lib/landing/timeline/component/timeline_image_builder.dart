import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';

typedef OnTapTimelineImage(DateTime timestamp);
mixin TimelineImageBuilder {
  Widget buildImageCell(String imageName, BuildContext context, Size cellSize,
          {String? annotation,
          GestureTapCallback? onTap,
          MachineStatus? status,
          double padding = 0}) =>
      Container(
          width: cellSize.width,
          height: cellSize.height,
          child: Padding(
              padding: EdgeInsets.all(padding),
              child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildImageWithLabelOnTop(
                            imageName, status, cellSize, padding, context),
                        if (annotation != null)
                          Text(annotation,
                              style: Theme.of(context).textTheme.headline6)
                      ]))));

  Stack _buildImageWithLabelOnTop(String imageName, MachineStatus? status,
          Size cellSize, double padding, BuildContext context) =>
      Stack(children: [
        _buildImageWithCorner(imageName, cellSize, padding, context),
        if (status != null && status != MachineStatus.working)
          _buildLabel(status, context),
      ]);

  Widget _buildImageWithCorner(
      String imageName, Size size, double padding, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, size, context);
    else
      return _buildRaster(imageName, size);
  }

  Widget _buildLabel(MachineStatus status, BuildContext context) => Align(
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

  Widget _buildSvg(String imageName, Size size, BuildContext context) =>
      Container(
        height: size.height,
        child: SvgPicture.asset(
          imageName,
          color: Theme.of(context).colorScheme.primary,
          fit: BoxFit.contain,
        ),
      );

  Widget _buildRaster(String imageName, Size size) => ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        imageName,
        width: size.width,
        fit: BoxFit.fitWidth,
      ));
}
