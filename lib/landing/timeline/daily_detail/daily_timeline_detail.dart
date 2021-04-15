import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _screenHeight * 0.618,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageAppBarContent(context),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  width: _screenWidth,
                  height: 50,
                  child: Text("$index"),
                );
              },
              childCount: 20,
            ),
          )
        ],
      ),
      // ListView(
      //   children: <Widget>[
      //     Container(
      //         width: _screenWidth - 64.0,
      //         child: Hero(
      //             tag: 'text' + widget.heroType.title,
      //             child: Material(
      //                 color: Colors.transparent,
      //                 child: Text(
      //                   '${widget.heroType.title}',
      //                   style: TextStyle(
      //                       fontSize: 24.0,
      //                       fontWeight: FontWeight.bold,
      //                       color: widget.heroType.materialColor),
      //                 )))),
      //     Container(
      //         width: _screenWidth - 64.0,
      //         child: Hero(
      //             tag: 'subtitle' + widget.heroType.title,
      //             child: Material(
      //                 color: Colors.transparent,
      //                 child: Text(
      //                   widget.heroType.subTitle,
      //                 )))),
      //   ],
      // ),
    );
  }

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
