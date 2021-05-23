import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

/// Build the image cell on a timeline. Stamp the image with idling or stationary,
/// if ths status says so. Display annotation or actions at the bottom.
typedef OnTapTimelineImage(DateTime timestamp);
mixin TimelineImageBuilder {
  Widget buildImageCell(String imageName,
          {String? annotation,
          required BuildContext context,
          required List<Widget> actions,
          required double width,
          GestureTapCallback? onTap,
          MachineStatus? status,
          bool? isHighlighted,
          String? indexLabel,
          double padding = 0}) =>
      Container(
          width: width,
          child: Padding(
              padding: EdgeInsets.all(padding),
              child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 3,
                          child: _buildImageWithLabel(imageName, status,
                              indexLabel, width, isHighlighted, padding, context),
                        ),
                        if (annotation != null || actions.isNotEmpty)
                          Flexible(
                            flex: 1,
                            child: _buildBottomSection(
                                annotation, context, actions),
                          )
                      ]))));

  Stack _buildImageWithLabel(
          String imageName,
          MachineStatus? status,
          String? indexLabel,
          double width,
          bool? isHighlighted,
          double padding,
          BuildContext context) =>
      Stack(children: [
        _buildImageWithCorner(imageName, width, isHighlighted, padding, context),
        if (status != null && status != MachineStatus.working)
          _buildTopLeftLabel(status, context),
        if (indexLabel != null) _buildBottomRightLabel(indexLabel, context)
      ]);

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
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(status.value().toUpperCase(),
                          style: Theme.of(context).textTheme.button)))));

  Widget _buildBottomRightLabel(String index, BuildContext context) => Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: EdgeInsets.only(bottom: 10, right: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(index,
                      style: Theme.of(context).textTheme.button)))));

  Widget _buildSvg(String imageName, double width, BuildContext context) =>
      Container(
          child: SvgPicture.asset(imageName,
              color: Theme.of(context).colorScheme.primary,
              fit: BoxFit.contain));

  Widget _buildRaster(String imageName, double width, bool? isHighlighted) =>
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _buildImage(imageName, width, isHighlighted));

  Row _buildBottomSection(
          String? annotation, BuildContext context, List<Widget> actions) =>
      Row(
        children: <Widget>[
              if (annotation != null)
                Text(annotation, style: Theme.of(context).textTheme.headline6),
              Spacer()
            ] +
            actions,
      );

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
              child: Image.asset(imageName, width: width, fit: BoxFit.fitWidth),
            )
          : Image.asset(imageName, width: width, fit: BoxFit.fitWidth);
}
