import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'daily_timeline.dart';

class TimelineCursor extends StatefulWidget {
  final MoveTimelineCursor moveTimelineCursor;
  final ScrollController scrollController;
  final double unitWidth;
  final int numberOfUnits;

  const TimelineCursor(
      {Key key,
      this.moveTimelineCursor,
      this.scrollController,
      this.unitWidth,
      this.numberOfUnits})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineCursorState();
}

class TimelineCursorState extends State<TimelineCursor> {
  double _timestamp = 0;
  BehaviorSubject _suspendListenerSubject = BehaviorSubject<bool>();
  StreamSubscription _subscription;
  VoidCallback _scrollLambda;

  TimelineCursorState() {
    _scrollLambda = () {
      setState(() {
        _timestamp =
            (widget.scrollController.offset / widget.unitWidth).roundToDouble();
      });
    };
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollLambda);
    _suspendControllerListenerWhenSwipeSlider();
    super.initState();
  }

  void _suspendControllerListenerWhenSwipeSlider() {
    _subscription = _suspendListenerSubject.asyncExpand((isSuspended) {
      if (isSuspended)
        return Stream.value(isSuspended);
      else
        return Stream.value(isSuspended).delay(Duration(seconds: 1));
    }).listen((isSuspended) => isSuspended
        ? widget.scrollController.removeListener(_scrollLambda)
        : widget.scrollController.addListener(_scrollLambda));
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollLambda);
    if (_subscription != null) _subscription.cancel();
    _suspendListenerSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Slider(
      value: _timestamp,
      onChangeStart: (_) => _suspendListenerSubject.add(true),
      onChangeEnd: (_) => _suspendListenerSubject.add(false),
      onChanged: (value) {
        setState(() {
          _timestamp = value;
        });
        widget.moveTimelineCursor(value);
      },
      min: 0,
      max: widget.numberOfUnits.toDouble() - 1,
      divisions: widget.numberOfUnits - 1);
}
