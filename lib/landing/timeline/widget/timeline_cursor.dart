import 'package:flutter/material.dart';

import 'daily_timeline.dart';

class TimelineCursor extends StatefulWidget {
  final MoveTimelineCursor moveTimelineCursor;

  const TimelineCursor({Key key, this.moveTimelineCursor}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineCursorState();
}

class TimelineCursorState extends State<TimelineCursor> {
  double timestamp = 0;

  @override
  Widget build(BuildContext context) => Slider(
        value: timestamp,
        onChanged: (value) {
          setState(() {
            timestamp = value;
          });
          widget.moveTimelineCursor(value);
        },
        min: 0,
        max: 9,
        divisions: 10,
      );
}
