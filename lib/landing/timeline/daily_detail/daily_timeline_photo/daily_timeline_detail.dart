import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_photo_viewer.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_gallery/mobile/daily_detail_gallery_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_gallery/web/daily_detail_gallery_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'daily_timeline_pullup_header.dart';

class HeroType {
  String title;
  String subTitle;
  List<DailyTimelineImageModel> images;
  int initialImageIndex;
  Color materialColor;

  HeroType(
      {required this.title,
      required this.subTitle,
      required this.images,
      required this.initialImageIndex,
      required this.materialColor});
}

class DailyTimelineDetail extends StatefulWidget {
  final HeroType heroType;

  const DailyTimelineDetail({Key? key, required this.heroType})
      : super(key: key);

  @override
  _DailyTimelineDetailState createState() => _DailyTimelineDetailState();
}

class _DailyTimelineDetailState extends State<DailyTimelineDetail> {
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
          child: DailyTimelinePullUpHeader()));

  SliverList _buildContentBody() => SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: _screenWidth,
              child: _buildImagePageView(context)),
          childCount: 1));

  Hero _buildImagePageView(BuildContext context) => Hero(
      tag: 'image' +
          (widget.heroType.images
                  .getOrNull<DailyTimelineImageModel>(
                      widget.heroType.initialImageIndex)
                  ?.imageName ??
              ""),
      child: PageView.builder(
          controller:
              PageController(initialPage: widget.heroType.initialImageIndex),
          scrollDirection: Axis.horizontal,
          itemCount: widget.heroType.images.length,
          itemBuilder: (_, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: _buildImageViewer(index),
                  ),
                  Flexible(
                    flex: 1,
                    child: DailyTimelinePhotoDownloader(),
                  )
                ],
              )));

  Widget _buildImageViewer(int index) =>
      widget.heroType.images
          .getOrNull<DailyTimelineImageModel>(index)
          ?.let((image) => DailyTimelinePhotoViewer(
                image,
                width: _screenWidth * 0.9,
                onTapImage: (BuildContext context) =>
                    getValueForScreenType<GestureTapCallback>(
                        context: context,
                        mobile: () => open(context, index),
                        tablet: () => open(context, index),
                        desktop: () => openDialog(context, index))(),
              )) ??
      Container();

  List<GalleryItem> _getGalleryItems() => widget.heroType.images
      .mapWithIndex((index, value) => GalleryItem(
          tag: value.timeString,
          statusLabel: [MachineStatus.idling, MachineStatus.stationary]
                  .contains(value.status)
              ? " [ ${value.status.value().toUpperCase()} ] "
              : "",
          resource: value.imageName,
          isSvg: value.imageName.contains(".svg")))
      .toList();

  void open(BuildContext context, final int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DailyDetailGalleryMobileView(
                galleryItems: _getGalleryItems(),
                initialIndex: index,
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background),
              )));

  void openDialog(BuildContext context, final int index) => showDialog(
      context: context,
      builder: (_) =>
          SimpleDialog(backgroundColor: Colors.transparent, children: [
            DailyDetailGalleryWebView(
              galleryItems: _getGalleryItems(),
              initialIndex: index,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
            )
          ]));
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
