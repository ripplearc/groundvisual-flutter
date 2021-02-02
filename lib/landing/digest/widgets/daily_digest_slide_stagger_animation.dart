import 'package:flutter/cupertino.dart';

import 'package:groundvisual_flutter/extensions/scoped.dart';

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
  Widget build(BuildContext context) {
    return _DailyDigestSlideStaggerAnimation(
        controller: _controller.view, image: image, imageSize: imageSize);
  }
}

class _DailyDigestSlideStaggerAnimation extends StatelessWidget {
  static const zoomLevel = 1.04;

  _DailyDigestSlideStaggerAnimation(
      {Key key, this.controller, this.image, this.imageSize})
      : _relativeRect = RelativeRectTween(
          begin: RelativeRect.fromSize(
              Rect.fromLTWH(
                  0, -imageSize.height, imageSize.width, imageSize.height),
              imageSize),
          end: RelativeRect.fromSize(
              Rect.fromLTWH(0, 0, imageSize.width, imageSize.height),
              imageSize),
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.3, curve: Curves.easeInOutCubic))),
        _size = TweenSequence(<TweenSequenceItem<Size>>[
          TweenSequenceItem<Size>(
              tween: Tween<Size>(
                begin: imageSize,
                end: imageSize * zoomLevel,
              ),
              weight: 900),
          TweenSequenceItem<Size>(
              tween: Tween<Size>(
                begin: imageSize * zoomLevel,
                end: imageSize,
              ),
              weight: 100),
        ]).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 0.9, curve: Curves.easeInOutCubic))),
        super(key: key);

  final AnimationController controller;
  final Animation<RelativeRect> _relativeRect;
  final Animation<Size> _size;

  final String image;
  final Size imageSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Positioned.fromRect(
        rect: _relativeRect.value
            .toRect(Rect.fromLTWH(0, 0, imageSize.width, imageSize.height))
            .let((rect) {
          Offset offset = (_size.value - imageSize);
          if (offset != Offset.zero) {
            return Rect.fromLTWH(-offset.dx / 2, -offset.dy / 2,
                _size.value.width, _size.value.height);
          } else {
            return rect;
          }
        }),
        child: Image.asset(image, fit: BoxFit.cover));
  }
}
