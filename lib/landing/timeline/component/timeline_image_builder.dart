import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

/// Build the widgets of the image cell on a timeline. Stamp the image
/// if the [status] is idling or stationary.
/// Outline the image if it is [isHighlighted].
/// Group the [annotation] or [actions] as one widget.
typedef OnTapTimelineImage(DateTime timestamp);
mixin TimelineImageBuilder {
  List<Widget> buildImageCellWidgets(String imageName,
          {required BuildContext context,
          required List<Widget> actions,
          required double width,
          required String heroAnimationTag,
          String? annotation,
          GestureTapCallback? onTap,
          MachineStatus? status,
          bool? isHighlighted,
          double padding = 0}) =>
      <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: padding),
          child: _buildImageWithLabel(imageName, status, onTap, width,
              isHighlighted, heroAnimationTag, padding, context),
        ),
        if (annotation != null || actions.isNotEmpty)
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: padding),
              child: _buildBottomSection(annotation, width, context, actions))
      ];

  Widget _buildImageWithLabel(
          String imageName,
          MachineStatus? status,
          GestureTapCallback? onTap,
          double width,
          bool? isHighlighted,
          String heroAnimationTag,
          double padding,
          BuildContext context) =>
      GestureDetector(
          onTap: onTap,
          child: Stack(children: [
            Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: heroAnimationTag,
                  child: _buildImageWithCorner(
                      imageName, width, isHighlighted, padding, context),
                )),
            if (status != null && status != MachineStatus.working)
              _buildTopLeftLabel(status, context),
          ]));

  Widget _buildImageWithCorner(String imageName, double width,
      bool? isHighlighted, double padding, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, width, context);
    else
      return _buildRaster(imageName, width, isHighlighted);
  }

  Widget _buildTopLeftLabel(MachineStatus status, BuildContext context) =>
      Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(status.value().toUpperCase(),
                          style: Theme.of(context).textTheme.button)))));

  Widget _buildSvg(String imageName, double width, BuildContext context) =>
      SvgPicture.asset(imageName,
          width: width,
          color: Theme.of(context).colorScheme.primary,
          fit: BoxFit.contain);

  Widget _buildRaster(String imageName, double width, bool? isHighlighted) =>
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _buildImage(imageName, width, isHighlighted));

  Widget _buildBottomSection(String? annotation, double width,
          BuildContext context, List<Widget> actions) =>
      Container(
          width: width,
          child: Row(
            children: <Widget>[
                  if (annotation != null)
                    Text(annotation,
                        style: Theme.of(context).textTheme.headline6),
                  Spacer()
                ] +
                actions,
          ));

  Widget _buildImage(String imageName, double width, bool? isHighlighted) =>
      (isHighlighted ?? false)
          ? Container(
              padding: EdgeInsets.all(2),
              // margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.orange,
                  width: 5,
                ),
              ),
              child: Image.asset(imageName,
                  width: width,
                  fit: BoxFit.fitWidth),
            )
          : Image.asset(imageName,
              width: width,
              fit: BoxFit.fitWidth);
}
