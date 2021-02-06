import 'package:flutter/material.dart';

class DailyDigestAnimationController extends StatefulWidget {
  final Function animatedWidgetBuilder;
  final int durationInMilliSeconds;

  const DailyDigestAnimationController(
      {Key key, this.animatedWidgetBuilder, this.durationInMilliSeconds = 4000})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DailyDigestAnimationControllerState(
      animatedWidgetBuilder, durationInMilliSeconds);
}

class _DailyDigestAnimationControllerState
    extends State<DailyDigestAnimationController>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final int durationInMilliSeconds;

  final Function buildAnimatedWidget;

  _DailyDigestAnimationControllerState(
      this.buildAnimatedWidget, this.durationInMilliSeconds);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: durationInMilliSeconds), vsync: this)
      ..forward();
  }

  @override
  Widget build(BuildContext context) => buildAnimatedWidget(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
