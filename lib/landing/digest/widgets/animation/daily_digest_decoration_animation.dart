import 'package:flutter/material.dart';

/// Animate the strip widgets that echos the debut of the image slide.
class DailyDigestDecorationAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<RelativeRect> _relativeRect;
  final RelativeRectTween tween;
  final Size imageSize;

  DailyDigestDecorationAnimation(
      {Key key, this.controller, this.imageSize, this.tween})
      : _relativeRect = tween.animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeInOutCubic))),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(animation: controller, builder: _buildAnimation);

  Widget _buildAnimation(BuildContext context, Widget child) =>
      Positioned.fromRect(
          rect: _relativeRect.value.toRect(imageRect(imageSize)),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
          ));

  static Rect imageRect(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height);
}
