import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/widgets/daily_detail_photo_view_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail_photo/widgets/photo_view_actions.dart';
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

class _DailyDetailPhotoMobileViewState extends State<DailyDetailPhotoMobileView>
    with DailyDetailPhotoViewBuilder, PhotoViewAccessories {
  late int currentIndex = widget.initialIndex;

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
          actions: buildActions(context, simplified: true)),
      body: _buildGallery());

  PhotoViewGallery _buildGallery() => PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (context, index) =>
            buildItem(context, widget.galleryItems, index),
        itemCount: widget.galleryItems.length,
        loadingBuilder: widget.loadingBuilder,
        backgroundDecoration: widget.backgroundDecoration,
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        scrollDirection: widget.scrollDirection,
      );

  Flex _buildTitle(BuildContext context) => Flex(
      direction: getValueForScreenType(
        context: context,
        mobile: Axis.vertical,
        tablet: Axis.horizontal,
        desktop: Axis.horizontal,
      ),
      children: buildTitleContent(widget.galleryItems, currentIndex, context));
}
