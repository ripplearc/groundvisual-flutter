import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailyDigestSlideAnimation2 extends StatefulWidget {
  final String image;
  final Size imageSize;

  const DailyDigestSlideAnimation2({Key key, this.image, this.imageSize})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _DailyDigestSlideAnimation2State(image, imageSize);
}

class _DailyDigestSlideAnimation2State extends State<DailyDigestSlideAnimation2>
    with TickerProviderStateMixin {
  AnimationController _controller;

  final String image;
  final Size imageSize;

  _DailyDigestSlideAnimation2State(this.image, this.imageSize);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 4000), vsync: this)
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DailyDigestSlideStaggerAnimation(
      controller: _controller.view, image: image, imageSize: imageSize);
}

class _DailyDigestSlideStaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<RelativeRect> _relativeRect;

  final String image;
  final Size imageSize;

  _DailyDigestSlideStaggerAnimation(
      {Key key, this.controller, this.image, this.imageSize})
      : _relativeRect = rectSequence(imageSize).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.9, curve: Curves.easeInOutCubic))),
        super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: _buildAnimation,
      );

  Widget _buildAnimation(BuildContext context, Widget child) =>
      Positioned.fromRect(
          rect: _relativeRect.value.toRect(imageRect(imageSize)),
          child: Image.asset(image, fit: BoxFit.cover));

  static const zoomLevel = 1.04;

  static Rect imageRect(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height);

  static RelativeRect _start(Size size) => RelativeRect.fromSize(
      _getRandomStartRect(size), size);

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
