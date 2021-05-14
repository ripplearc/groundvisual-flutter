import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/bloc/timeline_gallery_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_actions.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/widgets/timeline_gallery_view_builder.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Display the zoomable image in the full screen gallery.
class TimelineGalleryMobileView extends StatefulWidget {
  TimelineGalleryMobileView({
    this.loadingBuilder,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;

  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _TimelineGalleryMobileViewState();
  }
}

class _TimelineGalleryMobileViewState extends State<TimelineGalleryMobileView>
    with TimelineGalleryViewBuilder, TimelineGalleryViewAccessories {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineGalleryBloc, TimelineGalleryState>(
          builder: (context, state) => Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: _buildTitle(context, state.galleryItems),
                  actions: buildActions(context, simplified: true)),
              body: _buildGallery(state.galleryItems)));

  Widget _buildGallery(List<GalleryItem> galleryItems) => galleryItems
          .isNotEmpty
      ? PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) => buildItem(context, galleryItems, index),
          itemCount: galleryItems.length,
          loadingBuilder: widget.loadingBuilder,
          backgroundDecoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          pageController: widget.pageController,
          onPageChanged: onPageChanged,
          scrollDirection: widget.scrollDirection,
        )
      : Container();

  Widget _buildTitle(BuildContext context, List<GalleryItem> galleryItems) =>
      galleryItems.isNotEmpty
          ? Flex(
              direction: getValueForScreenType(
                context: context,
                mobile: Axis.vertical,
                tablet: Axis.horizontal,
                desktop: Axis.horizontal,
              ),
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildTitleContent(galleryItems, currentIndex, context))
          : Container();
}
