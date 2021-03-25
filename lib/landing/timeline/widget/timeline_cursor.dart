import 'package:flutter/material.dart';

class TimelineCursor extends StatefulWidget {
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
        },
        min: 0,
        max: 100,
      );
}
