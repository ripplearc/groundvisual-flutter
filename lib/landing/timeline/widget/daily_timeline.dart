import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/bloc/daily_timeline_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:groundvisual_flutter/landing/timeline/widget/listview_cursor.dart';
import 'package:groundvisual_flutter/landing/timeline/widget/timeline_images.dart';

typedef MoveTimelineCursor(double index);


/// Show the sampled timelapse images within a day.
class DailyTimeline extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DailyTimelineState();
}

class _DailyTimelineState extends State<DailyTimeline> {
  final _scrollController = ScrollController();
  final double cellWidth = 216;

  void _scrollToIndex(index) {
    _scrollController.animateTo(216 * index,
        duration: Duration(seconds: 1), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DailyTimelineBloc, DailyTimelineState>(
          buildWhen: (prev, curr) => curr is DailyTimelineImagesLoaded,
          builder: (context, state) {
            if (state is DailyTimelineImagesLoaded)
              return _buildTimelineContent(context, state.images);
            else
              return _buildTimelineContent(context, []);
          });

  Container _buildTimelineContent(
          BuildContext context, List<DailyTimelineImageModel> images) =>
      Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 280.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Timelapse',
                      style: Theme.of(context).textTheme.headline6),
                ),
                TimelineImages(
                  scrollController: _scrollController,
                  cellWidth: cellWidth,
                  images: images,
                ),
                ListViewCursor(
                  moveTimelineCursor: _scrollToIndex,
                  scrollController: _scrollController,
                  cellWidth: cellWidth,
                  numberOfUnits: images.length,
                )
              ]));
}
