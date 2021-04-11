import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Display the zoomable image in the full screen gallery.
class DailyDetailPhotoMobileView extends StatefulWidget {
  DailyDetailPhotoMobileView({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _DailyDetailPhotoMobileViewState();
  }
}

class _DailyDetailPhotoMobileViewState
    extends State<DailyDetailPhotoMobileView> {
  late int currentIndex = widget.initialIndex;
  static const double ScaleFactor = 3;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: _buildGallery());

  List<Widget> _buildActions() => [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.favorite_border_outlined)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.share_outlined)),
      ];

  Flex _buildTitle(BuildContext context) => Flex(
      direction: getValueForScreenType(
        context: context,
        mobile: Axis.vertical,
        tablet: Axis.horizontal,
        desktop: Axis.horizontal,
      ),
      children: widget.galleryItems
              .getOrNull<GalleryItem>(currentIndex)
              ?.let((item) => [
                    Text(item.tag,
                        style: Theme.of(context).textTheme.headline6),
                    if (item.statusLabel.isNotEmpty)
                      Text(item.statusLabel,
                          style: Theme.of(context).textTheme.subtitle1)
                  ]) ??
          []);

  PhotoViewGallery _buildGallery() => PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: widget.galleryItems.length,
        loadingBuilder: widget.loadingBuilder,
        backgroundDecoration: widget.backgroundDecoration,
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        scrollDirection: widget.scrollDirection,
      );

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) =>
      widget.galleryItems.getOrNull<GalleryItem>(index)?.let((item) =>
          item.isSvg ? _buildSvg(item, context) : _buildImageAsset(item)) ??
      _buildDefaultItem();

  PhotoViewGalleryPageOptions _buildSvg(
          GalleryItem item, BuildContext context) =>
      PhotoViewGalleryPageOptions.customChild(
        child: SvgPicture.asset(
          item.resource,
          color: Theme.of(context).colorScheme.primary,
          fit: BoxFit.contain,
        ),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
      );

  PhotoViewGalleryPageOptions _buildImageAsset(GalleryItem item) =>
      PhotoViewGalleryPageOptions(
        imageProvider: AssetImage(item.resource),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * ScaleFactor,
        heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
      );

  PhotoViewGalleryPageOptions _buildDefaultItem() =>
      PhotoViewGalleryPageOptions.customChild(
        child: Icon(Icons.broken_image_outlined, size: 180),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: "unknown"),
      );
}
