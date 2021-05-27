import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/drawing/clip_shadow_path.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_bar.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

import '../components/timeline_sheet_pullup_header.dart';

class TimelineSearchMobilePageTwo extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchMobilePageTwo({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  _TimelineSearchMobilePageTwoState createState() =>
      _TimelineSearchMobilePageTwoState();
}

class _TimelineSearchMobilePageTwoState extends State<TimelineSearchMobilePageTwo> {
  final Completer<GoogleMapController> _controller = Completer();
  late double _screenWidth;
  late double _mapHeight;
  late double _scrollViewTopOffset;
  static const double titleHeight = 70;
  static const double _mapBottomOffset = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _mapHeight = MediaQuery.of(context).size.height * 0.5;
    _scrollViewTopOffset = _mapHeight - _mapBottomOffset;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TimelineSearchBar()),
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

  Widget _buildTitleWithBorder(BuildContext context) => ClipShadowPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          )),
      shadow: Shadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(0, -5)),
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
      BuildContext context, List<TimelineImageModel> images) =>
      images.isNotEmpty
          ? PageView.builder(
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
          ))
          : Container();

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
