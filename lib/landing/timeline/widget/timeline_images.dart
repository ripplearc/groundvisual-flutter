import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(
      child: ListView.builder(
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
                        height: 120,
                        fit: BoxFit.fitWidth,
                      )),
                  Text('3:00 ~ 3:15',
                      style: Theme.of(context).textTheme.headline6)
                ],
              ))));
}
