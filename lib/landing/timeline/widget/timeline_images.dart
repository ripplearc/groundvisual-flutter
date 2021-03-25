import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineImages extends StatelessWidget {
  final ScrollController scrollController;

  const TimelineImages({Key key, this.scrollController}) : super(key: key);

  Widget build(BuildContext context) => Expanded(
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'images/thumbnails/${index + 1}.jpg',
                        width: 200,
                        fit: BoxFit.contain,
                      )),
                  Text('3:00 ~ 3:15',
                      style: Theme.of(context).textTheme.headline6)
                ],
              ))));
}
