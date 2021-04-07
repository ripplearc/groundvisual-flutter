import 'package:flutter/material.dart';

class DailyDigestAnimationController extends StatefulWidget {
  final Function animatedWidgetBuilder;
  final int durationInMilliSeconds;

  const DailyDigestAnimationController(
      {Key? key,
      required this.animatedWidgetBuilder,
      this.durationInMilliSeconds = 4000})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _DailyDigestAnimationControllerState(durationInMilliSeconds);
}

class _DailyDigestAnimationControllerState
    extends State<DailyDigestAnimationController>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final int durationInMilliSeconds;

  _DailyDigestAnimationControllerState(this.durationInMilliSeconds);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: durationInMilliSeconds), vsync: this)
      ..forward();
  }

  @override
  Widget build(BuildContext context) =>
      widget.animatedWidgetBuilder(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
