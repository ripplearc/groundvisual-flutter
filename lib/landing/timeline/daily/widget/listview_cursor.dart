import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'daily_timeline.dart';

/// The slider that can control the movement of the timelapse ListView as well as listens
/// to the movement and reflect that movement.
class ListViewCursor extends StatefulWidget {
  final MoveTimelineCursor? moveTimelineCursor;
  final GetTimestamp? getTimestamp;
  final ScrollController? scrollController;
  final int? animationDuration;
  final double cellWidth;
  final int numberOfUnits;

  const ListViewCursor({
    Key? key,
    required this.cellWidth,
    required this.numberOfUnits,
    this.moveTimelineCursor,
    this.getTimestamp,
    this.scrollController,
    this.animationDuration,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListViewCursorState();
}

class ListViewCursorState extends State<ListViewCursor> {
  double _currentIndex = 0;
  BehaviorSubject _suspendListenerSubject = BehaviorSubject<bool>();
  StreamSubscription? _subscription;
  VoidCallback? _scrollLambda;

  ListViewCursorState() {
    _scrollLambda = () {
      setState(() {
        _currentIndex =
            (widget.scrollController?.offset ?? 0 / widget.cellWidth)
                .roundToDouble();
      });
    };
  }

  @override
  void initState() {
    widget.scrollController?.addListener(_scrollLambda ?? () {});
    _suspendControllerListenerWhenSwipeSlider();
    super.initState();
  }

  void _suspendControllerListenerWhenSwipeSlider() {
    _subscription = _suspendListenerSubject.asyncExpand((isSuspended) {
      if (isSuspended)
        return Stream.value(isSuspended);
      else
        return Stream.value(isSuspended)
            .delay(Duration(seconds: widget.animationDuration ?? 1));
    }).listen((isSuspended) => isSuspended
        ? widget.scrollController?.removeListener(_scrollLambda ?? () {})
        : widget.scrollController?.addListener(_scrollLambda ?? () {}));
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollLambda ?? () {});
    if (_subscription != null) _subscription?.cancel();
    _suspendListenerSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SliderTheme(
      data: _buildSliderTheme(context),
      child: Slider(
        value: _currentIndex,
        onChangeStart: (_) => _suspendListenerSubject.add(true),
        onChangeEnd: (_) => _suspendListenerSubject.add(false),
        onChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
          widget.moveTimelineCursor?.call(value);
        },
        min: 0,
        max: max(0, widget.numberOfUnits.toDouble() - 1),
        divisions: max(1, widget.numberOfUnits - 1),
        label: widget.getTimestamp?.call(_currentIndex.round()),
      ));

  SliderThemeData _buildSliderTheme(BuildContext context) =>
      SliderTheme.of(context).copyWith(
        activeTrackColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Theme.of(context).colorScheme.onSurface,
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: Theme.of(context).colorScheme.primary,
        overlayColor: Theme.of(context).colorScheme.surface.withAlpha(128),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Theme.of(context).colorScheme.primary,
        inactiveTickMarkColor: Theme.of(context).colorScheme.onSurface,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Theme.of(context).colorScheme.secondary,
        valueIndicatorTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
      );
}
