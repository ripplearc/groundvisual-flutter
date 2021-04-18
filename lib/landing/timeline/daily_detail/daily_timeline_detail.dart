import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/mobile/daily_detail_photo_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/web/daily_detail_photo_web_view.dart';
import 'package:groundvisual_flutter/landing/timeline/model/daily_timeline_image_model.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
  late double _screenWidth;
  late double _screenHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  static const double kCoverHeightProportion = 0.15;
  static const double kBigBoxPadding = 8;
  static const double kBottomBigBoxPadding = 60;

  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: CustomScrollView(
  //       slivers: <Widget>[
  //         SliverAppBar(
  //           expandedHeight: _screenHeight * 0.618,
  //           flexibleSpace: FlexibleSpaceBar(
  //             background: _buildMapAppBarContent(context),
  //           ),
  //         ),
  //         SliverList(
  //           delegate: SliverChildBuilderDelegate((_, __) {
  //             return Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.orange,
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(10),
  //                       topRight: Radius.circular(10))),
  //               child: Column(
  //                 children: List.generate(
  //                     10,
  //                     (index) => Container(
  //                         child: ListTile(title: Text("$index nothing")))),
  //               ),
  //             );
  //           }, childCount: 1),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var topPadding = kCoverHeightProportion *
        kCoverHeightProportion *
        MediaQuery.of(context).size.height /
        (kCoverHeightProportion *
            (MediaQuery.of(context).size.height -
                kBigBoxPadding -
                kBottomBigBoxPadding));
    return Scaffold(
        body: Stack(children: [
      _buildMapAppBarContent(context),
      // SliverAppBar(
      //   expandedHeight: _screenHeight * 0.618,
      //   flexibleSpace: FlexibleSpaceBar(
      //     background: _buildMapAppBarContent(context),
      //   ),
      // ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),

              //width: MediaQuery.of(context).size.width * 0.9,
              //margin: EdgeInsets.symmetric(horizontal: kBigBoxPadding),
              decoration: BoxDecoration(
                //color: Colors.pink,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  child: CustomScrollView(
                    anchor: 0,
                    slivers: <Widget>[
                      _buildContentHeader(topPadding),
                      _buildContentBody()
                    ],
                  ))))
    ]));
  }

  SliverList _buildContentBody() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          width: _screenWidth,
          height: 50,
          color: Colors.red,
          child: Text("$index"),
        );
      },
      childCount: 20,
    ));
  }

  SliverPadding _buildContentHeader(double topPadding) => SliverPadding(
      padding: EdgeInsets.only(
        top: 200,
      ),
      sliver: SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _SliverPersistentHeaderDelegate(Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Center(
                  child: Text(
                'La casa de don Juan',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 32,
                    fontWeight: FontWeight.w800),
              ))))));

  Widget _buildMapAppBarContent(BuildContext context) =>
      Container(width: _screenWidth, height: 300, child: WorkZoneMap());

  Hero _buildImageAppBarContent(BuildContext context) => Hero(
        tag: 'image' +
            (widget.heroType.images
                    .getOrNull<DailyTimelineImageModel>(
                        widget.heroType.initialImageIndex)
                    ?.imageName ??
                ""),
        child: Container(
            width: _screenWidth,
            child: PageView.builder(
                controller: PageController(
                    initialPage: widget.heroType.initialImageIndex),
                scrollDirection: Axis.horizontal,
                itemCount: widget.heroType.images.length,
                itemBuilder: (_, index) => Container(
                    width: _screenWidth,
                    child: GestureDetector(
                      onTap: getValueForScreenType<GestureTapCallback>(
                          context: context,
                          mobile: () => open(context, index),
                          tablet: () => open(context, index),
                          desktop: () => openDialog(context, index)),
                      child: _buildImage(
                          widget.heroType.images
                                  .getOrNull<DailyTimelineImageModel>(index)
                                  ?.imageName ??
                              'assets/icon/excavator.svg',
                          context),
                    )))),
      );

  List<GalleryItem> _getGalleryItems() => widget.heroType.images
      .mapWithIndex((index, value) => GalleryItem(
          tag: value.timeString,
          statusLabel: [MachineStatus.idling, MachineStatus.stationary]
                  .contains(value.status)
              ? " [${value.status.value().toUpperCase()}]"
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

  Widget _buildImage(String imageName, BuildContext context) {
    if (imageName.contains(".svg"))
      return _buildSvg(imageName, context);
    else
      return _buildRaster(imageName);
  }

  SvgPicture _buildSvg(String imageName, BuildContext context) =>
      SvgPicture.asset(
        imageName,
        color: Theme.of(context).colorScheme.primary,
        fit: BoxFit.contain,
      );

  Image _buildRaster(String imageName) => Image.asset(
        imageName,
        fit: BoxFit.cover,
      );
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate(this.child);

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
