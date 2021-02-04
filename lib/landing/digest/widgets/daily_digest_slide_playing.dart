import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/model/digest_image_model.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

import 'daily_digest_slide_stagger_animation.dart';

/// Animate sliding in the next digest image, and pause when touching anywhere on the image.
class DailyDigestSlidePlaying extends StatelessWidget {
  final double padding;

  DailyDigestSlidePlaying({Key key, this.padding = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(
          buildWhen: (prev, curr) => curr is PlayDigestShowImage,
          builder: (context, state) {
            if (state is PlayDigestShowImage) {
              return GestureDetector(
                  onTap: () {
                    BlocProvider.of<PlayDigestBloc>(context).add(
                        PlayDigestPause(context, state.siteName, state.date));
                  },
                  child: _genAnimatedSlide(state.images));
            } else {
              return Container();
            }
          });

  Padding _genAnimatedSlide(DigestImageModel images) => Padding(
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(builder: (context, constraints) {
        final Size size = constraints.biggest;
        final Size decorationSize = _randomSize(size);
        final Offset decorationOffset = _randomOffset(size);
        return Stack(
          children: [
            images.currentImage != null
                ? _genStaticImage(images.currentImage)
                : Container(),
            images.nextImage != null
                ? DailyDigestAnimationController(
                    key: Key(images.nextImage),
                    animatedWidgetBuilder:
                        _getSlideAnimationBuilder(images.nextImage, size))
                : Container(),
            images.nextImage != null
                ? DailyDigestAnimationController(
                    key: Key(images.nextImage + "_horizontal_decoration"),
                    animatedWidgetBuilder: _getDecorationAnimationBuilder(
                        size,
                        _getHorizontalDecorationTween(
                            size, decorationOffset, decorationSize.width)))
                : Container(),
            images.nextImage != null
                ? DailyDigestAnimationController(
                    key: Key(images.nextImage + "_vertical_decoration"),
                    animatedWidgetBuilder: _getDecorationAnimationBuilder(
                        size,
                        _getVerticalDecorationTween(
                            size, decorationOffset, decorationSize.height)))
                : Container()
          ],
        );
      }));

  Function _getSlideAnimationBuilder(String image, Size imageSize) =>
      (AnimationController controller) => DailyDigestSlideAnimation(
          controller: controller, image: image, imageSize: imageSize);

  final double thickness = 2;

  Tween _getHorizontalDecorationTween(
          Size benchmarkSize, Offset offset, double length) =>
      RelativeRectTween(
          begin: RelativeRect.fromSize(
              Rect.fromLTWH(-benchmarkSize.width, offset.dy, length, thickness),
              benchmarkSize),
          end: RelativeRect.fromSize(
              Rect.fromLTWH(
                  length < benchmarkSize.width &&
                          offset.dx * 2 > benchmarkSize.width
                      ? offset.dx
                      : 0,
                  offset.dy,
                  length,
                  thickness),
              benchmarkSize));

  Tween _getVerticalDecorationTween(
          Size benchmarkSize, Offset offset, length) =>
      RelativeRectTween(
          begin: RelativeRect.fromSize(
              Rect.fromLTWH(offset.dx, benchmarkSize.height, thickness, length),
              benchmarkSize),
          end: RelativeRect.fromSize(
              Rect.fromLTWH(
                  offset.dx,
                  length < benchmarkSize.height &&
                          offset.dy * 2 > benchmarkSize.height
                      ? offset.dy
                      : 0,
                  thickness,
                  length),
              benchmarkSize));

  final double xDecorationAnchor = 80;
  final double yDecorationAnchor = 40;
  final random = Random();

  Offset _randomOffset(Size size) => Offset(
      random.nextBool() ? xDecorationAnchor : size.width - xDecorationAnchor,
      random.nextBool() ? yDecorationAnchor : size.height - yDecorationAnchor);

  Size _randomSize(Size size) => random.nextInt(3).let((seed) {
        switch (seed) {
          case 0:
            return size;
          case 1:
            return Size(size.width, yDecorationAnchor);
          case 2:
            return Size(xDecorationAnchor, size.height);
          default:
            return Size.zero;
        }
      });

  Function _getDecorationAnimationBuilder(Size size, Tween tween) =>
      (AnimationController controller) => DailyDigestDecorationAnimation(
          controller: controller, imageSize: size, tween: tween);

  Image _genStaticImage(String images) => Image.asset(
        images,
        fit: BoxFit.cover,
      );
}
