import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/drawing/clip_shadow_path.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_bar.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

import '../components/timeline_sheet_header.dart';

/// [TimelineSearchMobilePage] is the search page optimized for the search layout.
/// [initialImageIndex] is the one being displayed at the top of viewport when the
/// search page is first loaded.
/// See also:
///  * [TimelineSearchWebPage] for web layout.
///  * [TimelineSearchTabletPage] for tablet layout.
class TimelineSearchMobilePage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchMobilePage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  _TimelineSearchMobilePageState createState() =>
      _TimelineSearchMobilePageState();
}

class _TimelineSearchMobilePageState extends State<TimelineSearchMobilePage> {
  final Completer<GoogleMapController> _controller = Completer();
  late Size _screenSize;
  late double _contentHeight;
  static const double titleHeight = 70;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _contentHeight = MediaQuery.of(context).size.height * 0.55;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TimelineSearchBar()),
      body: Stack(children: [_buildMapHeader(context), _buildContent()]));

  Widget _buildMapHeader(BuildContext context) =>
      WorkZoneMap(bottomPadding: _contentHeight, mapController: _controller);

  Align _buildContent() => Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: double.infinity,
          height: _screenSize.height * 0.55,
          child: Column(
            children: [_buildContentTitle(), _buildContentBody()],
          )));

  Widget _buildContentTitle() =>
      Container(height: titleHeight, child: _buildTitleWithBorder(context));

  Widget _buildTitleWithBorder(BuildContext context) => ClipShadowPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      )),
      shadow: Shadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(0, -5)),
      child: Container(
          color: Theme.of(context).colorScheme.background,
          child: TimelineSheetHeader(width: _screenSize.width)));

  Widget _buildContentBody() =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (blocContext, state) => Expanded(
              child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.background,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildImageListView(context, state.images))));

  Widget _buildImageListView(
          BuildContext context, List<TimelineImageModel> images) =>
      ScrollablePositionedList.separated(
          separatorBuilder: (context, index) =>
              Divider(color: Theme.of(context).colorScheme.onBackground),
          initialScrollIndex: widget.initialImageIndex,
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) =>
              BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
                  builder: (context, state) =>
                      state.images
                          .getOrNull<TimelineImageModel>(index)
                          ?.let((image) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildImageItem(
                                        index, image, state.images, context) +
                                    [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: TimelinePhotoDownloader()),
                                    ],
                              )) ??
                      Container()));

  List<Widget> _buildImageItem(int index, TimelineImageModel image,
          List<TimelineImageModel> images, BuildContext context) =>
      TimelineSearchImageBuilder(image,
              index: index,
              images: images,
              width: _screenSize.width * 0.9,
              enableHeroAnimation: index == widget.initialImageIndex)
          .buildSearchImageCellWidgets(context);
}
