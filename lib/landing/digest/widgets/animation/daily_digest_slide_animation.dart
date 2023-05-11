import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Animate the debut of the image slide.
class DailyDigestSlideAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<RelativeRect> _relativeRect;

  final String imageUrl;
  final Size imageSize;

  DailyDigestSlideAnimation(
      {Key? key,
      required this.controller,
      required this.imageUrl,
      required this.imageSize})
      : _relativeRect = rectSequence(imageSize).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.9, curve: Curves.easeInOutCubic))),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(animation: controller, builder: _buildAnimation);

  Widget _buildAnimation(BuildContext context, Widget? child) =>
      Positioned.fromRect(
          rect: _relativeRect.value.toRect(imageRect(imageSize)),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ));

  static const zoomLevel = 1.04;

  static Rect imageRect(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height);

  static RelativeRect _start(Size size) =>
      RelativeRect.fromSize(_getRandomStartRect(size), size);

  static Rect _getRandomStartRect(Size size) => [
        Rect.fromLTWH(0, -size.height, size.width, size.height),
        Rect.fromLTWH(0, size.height, size.width, size.height),
        Rect.fromLTWH(size.width, 0, size.width, size.height),
        Rect.fromLTWH(-size.width, 0, size.width, size.height),
      ].elementAt(Random().nextInt(4));

  static RelativeRect _end(Size size) =>
      RelativeRect.fromSize(imageRect(size), size);

  static RelativeRect zoomInRect(Size size) => RelativeRect.fromSize(
      Rect.fromLTWH(
          -size.width * (zoomLevel - 1) / 2,
          -size.height * (zoomLevel - 1) / 2,
          size.width * zoomLevel,
          size.height * zoomLevel),
      size);

  static TweenSequence<RelativeRect> rectSequence(Size size) => TweenSequence([
        TweenSequenceItem(
            tween: RelativeRectTween(begin: _start(size), end: _end(size)),
            weight: 50),
        TweenSequenceItem(
            tween: RelativeRectTween(begin: _end(size), end: zoomInRect(size)),
            weight: 800),
        TweenSequenceItem(
            tween: RelativeRectTween(begin: zoomInRect(size), end: _end(size)),
            weight: 50)
      ]);
}
