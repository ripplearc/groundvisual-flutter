import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/bloc/timeline_gallery_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_view_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Display the image in the full screen gallery, with optimization for Web. It is not zoomable
/// and no amnimation from go from page to page.
class TimelineGalleryWebView extends StatefulWidget {
  TimelineGalleryWebView({
    this.loadingBuilder,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _TimelineGalleryWebViewState();
  }
}

class _TimelineGalleryWebViewState extends State<TimelineGalleryWebView>
    with TimelineGalleryViewBuilder, TimelineGalleryViewAccessories {
  late int currentIndex = widget.initialIndex;
  final double arrowSize = 30;
  final double titleHeight = 60;
  final backgroundDecoration = BoxDecoration(color: Colors.transparent);

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineGalleryBloc, TimelineGalleryState>(
          builder: (context, state) => Container(
                decoration: BoxDecoration(color: Colors.transparent),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.95,
                child: state.galleryItems.isNotEmpty
                    ? Stack(
                        children: <Widget>[
                          _buildGallery(state.galleryItems),
                          _buildHeader(state.galleryItems),
                          if (currentIndex > 0) _buildBackwardArrow(),
                          if (currentIndex < (state.galleryItems.length - 1))
                            _buildForwardArrow(state.galleryItems.length)
                        ],
                      )
                    : Container(),
              ));

  Widget _buildHeader(List<GalleryItem> galleryItems) => Align(
      alignment: Alignment.topCenter,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buildTitleContent(galleryItems, currentIndex, context,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.apply(fontWeightDelta: 2)) +
              [Spacer()] +
              buildActions(context, simplified: false) +
              _buildCloseButton()));

  List<Widget> _buildCloseButton() => [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
                icon: Icon(Icons.close_outlined, size: 30),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => Navigator.of(context).pop()))
      ];

  Widget _buildGallery(List<GalleryItem> galleryItems) => Padding(
      padding: EdgeInsets.only(top: titleHeight),
      child: PhotoViewGallery.builder(
          builder: (context, index) => buildItem(context, galleryItems, index),
          itemCount: galleryItems.length,
          loadingBuilder: widget.loadingBuilder,
          backgroundDecoration: backgroundDecoration,
          pageController: widget.pageController,
          onPageChanged: onPageChanged,
          scrollDirection: widget.scrollDirection));

  Align _buildForwardArrow(int length) => Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
          child: _buildArrow(Icons.arrow_forward_ios_outlined),
          onTap: () => widget.pageController.jumpToPage(
              min((widget.pageController.page ?? 0).toInt() + 1, length - 1))));

  Align _buildBackwardArrow() => Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
          child: _buildArrow(Icons.arrow_back_ios_outlined),
          onTap: () => widget.pageController.jumpToPage(
              max(0, (widget.pageController.page ?? 0).toInt() - 1))));

  ClipOval _buildArrow(IconData? data) => ClipOval(
      child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(data, size: arrowSize))));
}
