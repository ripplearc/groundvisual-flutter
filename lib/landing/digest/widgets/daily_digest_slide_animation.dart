import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class DailyDigestSlideAnimation extends StatelessWidget {
  final String image;
  final Size imageSize;
  final Random random = Random();

  DailyDigestSlideAnimation({Key key, this.image, this.imageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _DailyDigestPositionAnimation(
        key: Key(image),
        image: image,
        animationTimeInMilliSeconds: 1000,
        beginRect: _getRandomBeginRect(imageSize),
        imageSize: imageSize,
      );

  Rect _getRandomBeginRect(Size imageSize) => [
        Rect.fromLTWH(0, -imageSize.height, imageSize.width, imageSize.height),
        Rect.fromLTWH(0, imageSize.height, imageSize.width, imageSize.height),
        Rect.fromLTWH(imageSize.width, 0, imageSize.width, imageSize.height),
        Rect.fromLTWH(-imageSize.width, 0, imageSize.width, imageSize.height),
      ].elementAt(random.nextInt(4));
}

/// This is the stateful widget that the main application instantiates.
class _DailyDigestPositionAnimation extends StatefulWidget {
  final String image;
  final int animationTimeInMilliSeconds;
  final Rect beginRect;
  final Size imageSize;

  _DailyDigestPositionAnimation(
      {Key key,
      this.image,
      this.animationTimeInMilliSeconds,
      this.beginRect,
      this.imageSize})
      : super(key: key);

  @override
  _DailyDigestPositionAnimationState createState() =>
      _DailyDigestPositionAnimationState(
          image, animationTimeInMilliSeconds, beginRect, imageSize);
}

/// This is the private State class that goes with MyStatefulWidget.
class _DailyDigestPositionAnimationState
    extends State<_DailyDigestPositionAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<RelativeRect> _relativeRect;
  final String image;
  final int animationTimeInMilliSeconds;
  final Rect beginRect;
  final Size imageSize;

  _DailyDigestPositionAnimationState(this.image,
      this.animationTimeInMilliSeconds, this.beginRect, this.imageSize);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: animationTimeInMilliSeconds),
      vsync: this,
    )..forward();

    _relativeRect = RelativeRectTween(
      begin: RelativeRect.fromSize(beginRect, imageSize),
      end: RelativeRect.fromSize(
          Rect.fromLTWH(0, 0, imageSize.width, imageSize.height), imageSize),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => PositionedTransition(
        rect: _relativeRect,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      );
}
