import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/bloc/daily_timeline_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/widget/timeline_images.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_detail.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:groundvisual_flutter/extensions/date.dart';

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
      child: BlocConsumer<DailyTimelineBloc, DailyTimelineState>(
          listenWhen: (prev, curr) => curr is DailyTimelineNavigateToDetailPage,
          listener: (context, state) {
            if (state is DailyTimelineNavigateToDetailPage) {
              _navigateToDetailPage(
                  context, state.images, state.initialImageIndex);
            }
          },
          buildWhen: (prev, curr) => curr is DailyTimelineImagesLoaded,
          builder: (context, state) {
            if (state is DailyTimelineImagesLoaded)
              return _buildTimelineContent(context, state.images);
            else
              return _buildTimelineContent(context, []);
          }));

  Container _buildTimelineContent(
          BuildContext context, List<DailyTimelineImageModel> images) =>
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
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ),
                Flexible(
                  flex: 3,
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
                        : images[index].startTime.toHourMinuteString(),
                    scrollController: _scrollController,
                    cellWidth: cellWidth,
                    numberOfUnits: images.length,
                    animationDuration: animationDuration,
                  ),
                )
              ]));

  void _navigateToDetailPage(BuildContext context,
      List<DailyTimelineImageModel> images, int initialImageIndex) {
    Navigator.of(context).push(PageRouteBuilder(
        fullscreenDialog: true,
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            DailyTimelineDetail(
                heroType: HeroType(
                    title: "3:00 PM ~ 3:15 PM",
                    subTitle: "Working",
                    images: images,
                    initialImageIndex: initialImageIndex,
                    materialColor: Theme.of(context).colorScheme.primary)),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) =>
            FadeTransition(
              opacity: animation,
              child: child,
            )));
  }
}
