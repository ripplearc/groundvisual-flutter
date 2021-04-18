import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/landing/timeline/component/timeline_image_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/mobile/daily_detail_photo_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/web/daily_detail_photo_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

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

class _DailyTimelineDetailState extends State<DailyTimelineDetail>
    with TimelineImageBuilder {
  late double _screenWidth;
  static const double topPadding = 300;
  late double headerHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    headerHeight = getValueForScreenType<double>(
        context: context, mobile: 300, tablet: 700, desktop: 700);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(children: [
        _buildMapHeader(context),
        _buildContent(),
      ]));

  Widget _buildMapHeader(BuildContext context) => Container(
      width: _screenWidth, height: topPadding + 30, child: WorkZoneMap());

  Align _buildContent() => Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildContentTitle(topPadding),
              _buildContentBody()
            ],
          )));

  SliverPadding _buildContentTitle(double topPadding) => SliverPadding(
      padding: EdgeInsets.only(top: topPadding),
      sliver: SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _SliverPersistentHeaderDelegate(
              Container(
                  width: double.infinity,
                  height: headerHeight,
                  child: _buildTitleWithBorder(context)),
              height: headerHeight)));

  SliverList _buildContentBody() => SliverList(
          delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0)
            return Container(); //_buildImagePageView(context);
          else
            return Container(
              width: _screenWidth,
              height: 50,
              color: Colors.red,
              child: Text("$index"),
            );
        },
        childCount: 20,
      ));

  Widget _buildTitleWithBorder(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
          color: Colors.orange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello World"),
              Expanded(
                  child: Container(
                      width: _screenWidth * 0.9,
                      child: _buildImagePageView(context)))
            ],
          )));

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
          itemBuilder: (_, index) =>
              widget.heroType.images
                  .getOrNull<DailyTimelineImageModel>(index)
                  ?.let((image) => buildImageCell(
                        image.imageName,
                        context,
                        Size(_screenWidth * 0.9, topPadding * 0.8),
                        status: image.status,
                        annotation: "3:00",
                        onTap: () => getValueForScreenType<GestureTapCallback>(
                            context: context,
                            mobile: () => open(context, index),
                            tablet: () => open(context, index),
                            desktop: () => openDialog(context, index))(),
                      )) ??
              Container()));

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
          builder: (context) => DailyDetailPhotoMobileView(
                galleryItems: _getGalleryItems(),
                initialIndex: index,
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background),
              )));

  void openDialog(BuildContext context, final int index) => showDialog(
      context: context,
      builder: (_) =>
          SimpleDialog(backgroundColor: Colors.transparent, children: [
            DailyDetailPhotoWebView(
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
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
