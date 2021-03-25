import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/timeline/widget/timeline_cursor.dart';
import 'package:groundvisual_flutter/landing/timeline/widget/timeline_images.dart';

class DailyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 280.0,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: Text('Working Time',
                    style: Theme.of(context).textTheme.headline6)),
            TimelineImages(),
            TimelineCursor()
          ]));
}
