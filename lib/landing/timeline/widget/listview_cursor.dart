import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'daily_timeline.dart';

/// The slider that can control the movement of the timelapse ListView as well as listens
/// to the movement and reflect that movement.
class ListViewCursor extends StatefulWidget {
  final MoveTimelineCursor moveTimelineCursor;
  final ScrollController scrollController;
  final double cellWidth;
  final int numberOfUnits;

  const ListViewCursor(
      {Key key,
      this.moveTimelineCursor,
      this.scrollController,
      this.cellWidth,
      this.numberOfUnits})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ListViewCursorState();
}

class ListViewCursorState extends State<ListViewCursor> {
  double _timestamp = 0;
  BehaviorSubject _suspendListenerSubject = BehaviorSubject<bool>();
  StreamSubscription _subscription;
  VoidCallback _scrollLambda;

  ListViewCursorState() {
    _scrollLambda = () {
      setState(() {
        _timestamp =
            (widget.scrollController.offset / widget.cellWidth).roundToDouble();
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
      max: max(0, widget.numberOfUnits.toDouble() - 1),
      divisions: max(1, widget.numberOfUnits - 1));
}
