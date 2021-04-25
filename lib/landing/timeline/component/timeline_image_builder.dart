import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';

typedef OnTapTimelineImage(DateTime timestamp);
mixin TimelineImageBuilder {
  Widget buildImageCell(String imageName,
          {String? annotation,
          required BuildContext context,
          required List<Widget> actions,
          required double width,
          GestureTapCallback? onTap,
          MachineStatus? status,
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
                          child: _buildImageWithLabelOnTop(
                              imageName, status, width, padding, context),
                        ),
                        if (annotation != null || actions.isNotEmpty)
                          Flexible(
                            flex: 1,
                            child: _buildBottomSection(
                                annotation, context, actions),
                          )
                      ]))));

  Stack _buildImageWithLabelOnTop(String imageName, MachineStatus? status,
          double width, double padding, BuildContext context) =>
      Stack(children: [
        _buildImageWithCorner(imageName, width, padding, context),
        if (status != null && status != MachineStatus.working)
          _buildLabel(status, context),
      ]);

  Widget _buildImageWithCorner(
      String imageName, double width, double padding, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, width, context);
    else
      return _buildRaster(imageName, width);
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
                  child: Text(status.value().toUpperCase(),
                      style: Theme.of(context).textTheme.button)))));

  Widget _buildSvg(String imageName, double width, BuildContext context) =>
      Container(
          child: SvgPicture.asset(imageName,
              color: Theme.of(context).colorScheme.primary,
              fit: BoxFit.contain));

  Widget _buildRaster(String imageName, double width) => ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(imageName, width: width, fit: BoxFit.fitWidth));

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
}
