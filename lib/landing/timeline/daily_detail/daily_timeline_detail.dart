import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/mobile/daily_detail_photo_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';

class HeroType {
  String title;
  String subTitle;
  List<String?> images;
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
            expandedHeight: _screenHeight * (1 - 0.618),
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

  Hero _buildImageAppBarContent(BuildContext context) {
    return Hero(
      tag: 'image' +
          widget.heroType.images.getOrNull(widget.heroType.initialImageIndex),
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
                    onTap: () {
                      open(context, index);
                    },
                    child: _buildImage(
                        widget.heroType.images.getOrNull(index) ??
                            'assets/icon/excavator.svg',
                        context),
                  )))),
    );
  }

  void openDialog(BuildContext context, final int index) => showDialog(
      context: context,
      builder: (_) => SimpleDialog(
            backgroundColor: Colors.transparent,
            // contentPadding: const EdgeInsets.all(0),
            // insetPadding: const EdgeInsets.all(0),
            children: [
              DailyDetailPhotoMobileView(
                galleryItems: widget.heroType.images
                    .mapWithIndex((index, value) => GalleryItem(
                        id: "tag$index",
                        resource: value ?? "",
                        isSvg: value?.contains(".svg") ?? false))
                    .toList(),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                initialIndex: index,
                scrollDirection: Axis.horizontal,
              ),
            ],
          ));

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyDetailPhotoMobileView(
          galleryItems: widget.heroType.images
              .mapWithIndex((index, value) => GalleryItem(
                  id: "tag$index",
                  resource: value ?? "",
                  isSvg: value?.contains(".svg") ?? false))
              .toList(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

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
