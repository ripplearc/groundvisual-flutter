import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/bloc/daily_timeline_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/widget/timeline_images.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

import '../../component/scrollable_view_cursor.dart';

typedef MoveTimelineCursor(double index);
typedef String GetTimestamp(int index);

/// Show the sampled timelapse images within a day.
class DailyTimeline extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DailyTimelineState();
}

class _DailyTimelineState extends State<DailyTimeline> {
  final _scrollController = ScrollController();
  final double cellWidth = 216;
  final int animationDuration = 1;

  void _scrollToIndex(index) {
    _scrollController.animateTo(cellWidth * index,
        duration: Duration(seconds: animationDuration), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: BlocBuilder<DailyTimelineBloc, DailyTimelineState>(
          buildWhen: (prev, curr) => curr is DailyTimelineImagesLoaded,
          builder: (context, state) =>
              _buildTimelineContent(context, state.images)));

  Container _buildTimelineContent(
          BuildContext context, List<TimelineImageModel> images) =>
      Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 280.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: ListTile(
                    title: Text('Timelapse',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: TimelineImages(
                    scrollController: _scrollController,
                    cellSize: Size(cellWidth, 120),
                    images: images,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ScrollableViewCursor(
                    moveTimelineCursor: _scrollToIndex,
                    getTimestamp: (index) => images.isEmpty
                        ? "??:??"
                        : images[index]
                            .downloadingModel
                            .timeRange
                            .start
                            .toHourMinuteString(),
                    scrollController: _scrollController,
                    cellWidth: cellWidth,
                    numberOfUnits: images.length,
                    animationDuration: animationDuration,
                  ),
                )
              ]));
}
