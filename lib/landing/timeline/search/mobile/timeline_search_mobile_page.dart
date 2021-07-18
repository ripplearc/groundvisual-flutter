import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/drawing/clip_shadow_path.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/images/timeline_search_images_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/component/map/timeline_workzone_map_mixin.dart';
import 'package:groundvisual_flutter/landing/timeline/search/mobile/timeline_mobile_search_bar.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

class _TimelineSearchMobilePageState extends State<TimelineSearchMobilePage>
    with WorkZoneMapBuilder {
  final Completer<GoogleMapController> _controller = Completer();
  late Size _screenSize;
  late double _contentHeight;
  static const double titleHeight = 70;

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  StreamSubscription? _highlightDelaySubscription;

  int? prevMin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _contentHeight = MediaQuery.of(context).size.height * 0.55;
  }

  @override
  void initState() {
    super.initState();
    _detectCurrentHighlightedItem();
  }

  void _detectCurrentHighlightedItem() {
    _itemPositionsListener.itemPositions.addListener(() {
      _highlightDelaySubscription?.cancel();
      int value = _itemPositionsListener.itemPositions.value
          .where(this._itemIsAtLeastHalfVisible)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;

      _highlightDelaySubscription = Future.delayed(Duration(milliseconds: 180))
          .asStream()
          .listen((event) {
        if (value != prevMin) {
          setState(() {
            prevMin = value;
            BlocProvider.of<TimelineSearchImagesBloc>(context)
                .add(HighlightImage(value));
          });
        }
      });
    });
  }

  bool _itemIsAtLeastHalfVisible(ItemPosition position) =>
      position.itemTrailingEdge > 0 &&
      position.itemLeadingEdge.abs() < position.itemTrailingEdge.abs();

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(children: [
        buildMap(context, _controller, bottomPadding: _contentHeight),
        _buildContent()
      ]));

  PreferredSize _buildAppBar() => PreferredSize(
      preferredSize: Size.fromHeight(150.0), child: TimelineMobileSearchBar());

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
      BlocConsumer<TimelineSearchImagesBloc, TimelineSearchImagesState>(
          listener: (context, state) {
            prevMin?.let((index) {
              if (state is TimelineSearchResultsHighlighted) {
                state.images
                    .getOrNull<TimelineImageModel>(index)
                    ?.downloadingModel
                    .timeRange
                    .let((timeRange) => BlocProvider.of<WorkZoneBloc>(context)
                        .add(HighlightWorkZoneOfTime(timeRange)));
              }
            });
          },
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
          itemPositionsListener: _itemPositionsListener,
          itemBuilder: (_, index) =>
              images.getOrNull<TimelineImageModel>(index)?.let((image) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildImageItem(index, image, images, context) +
                        [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: TimelinePhotoDownloader()),
                        ],
                  )) ??
              Container());

  List<Widget> _buildImageItem(int index, TimelineImageModel image,
          List<TimelineImageModel> images, BuildContext context) =>
      TimelineSearchImageBuilder(image,
              index: index,
              images: images,
              width: _screenSize.width * 0.9,
              enableHeroAnimation: index == widget.initialImageIndex)
          .buildSearchImageCellWidgets(context);
}
