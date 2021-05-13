import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/widgets/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/widgets/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

import 'timeline_sheet_pullup_header.dart';

class TimelineSearchPage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchPage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  _TimelineSearchPageState createState() => _TimelineSearchPageState();
}

class _TimelineSearchPageState extends State<TimelineSearchPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late double _screenWidth;
  late double _mapHeight;
  late double _scrollViewTopOffset;
  static const double titleHeight = 100;
  static const double _mapBottomOffset = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _mapHeight = MediaQuery.of(context).size.height * 0.392;
    _scrollViewTopOffset = _mapHeight - _mapBottomOffset;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Stack(children: [_buildMapHeader(context), _buildContent()]));

  Widget _buildMapHeader(BuildContext context) => Container(
      width: _screenWidth,
      height: _mapHeight,
      child: WorkZoneMap(
          bottomPadding: _mapBottomOffset, mapController: _controller));

  Align _buildContent() => Align(
      alignment: Alignment.bottomCenter,
      child: CustomScrollView(
          slivers: <Widget>[_buildContentTitle(), _buildContentBody()]));

  SliverPadding _buildContentTitle() => SliverPadding(
      padding: EdgeInsets.only(top: _scrollViewTopOffset),
      sliver: SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _SliverPersistentHeaderDelegate(
              Container(
                  width: double.infinity,
                  height: titleHeight,
                  child: _buildTitleWithBorder(context)),
              height: titleHeight)));

  Widget _buildTitleWithBorder(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
          color: Theme.of(context).colorScheme.background,
          child: TimelineSheetPullUpHeader()));

  SliverList _buildContentBody() => SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
                  builder: (blocContext, state) => Container(
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.background,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: _screenWidth,
                      child: _buildImagePageView(context, state.images))),
          childCount: 1));

  Widget _buildImagePageView(
      BuildContext context, List<TimelineImageModel> images) {
    if (images.isNotEmpty) {
      int index = widget.initialImageIndex.clamp(0, images.length);
      return Hero(
          tag: 'image' +
              (images.getOrNull<TimelineImageModel>(index)?.imageName ?? ""),
          child: PageView.builder(
              controller: PageController(initialPage: widget.initialImageIndex),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 2, child: _buildImageViewer(index)),
                      Flexible(
                        flex: 1,
                        child: TimelinePhotoDownloader(),
                      )
                    ],
                  )));
    } else {
      return Container();
    }
  }

  Widget _buildImageViewer(int index) =>
      TimelineSearchPhotoViewer(index, width: _screenWidth * 0.9);
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate(this.child, {required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
