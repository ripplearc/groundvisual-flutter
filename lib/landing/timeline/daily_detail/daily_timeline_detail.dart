import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240,
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
          height: 230.0,
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

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.heroType.images
              .mapWithIndex((index, value) => GalleryExampleItem(
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
        fit: BoxFit.fitHeight,
      );
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: SvgPicture.asset(
              item.resource,
              color: Theme.of(context).colorScheme.primary,
              fit: BoxFit.contain,
            ),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(item.resource),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          );
  }
}

class GalleryExampleItem {
  GalleryExampleItem({
    required this.id,
    required this.resource,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final bool isSvg;
}
