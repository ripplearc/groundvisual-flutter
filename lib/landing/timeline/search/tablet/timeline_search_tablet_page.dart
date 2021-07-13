import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/images/timeline_search_images_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_sheet_header.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_workzone_map_mixin.dart';
import 'package:groundvisual_flutter/landing/timeline/search/tablet/timeline_tablet_search_bar.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// [TimelineSearchTabletPage] is the search page optimized for the tablet layout.
/// [initialImageIndex] is the one being displayed at the top of viewport when the
/// search page is first loaded.
/// The tablet highlights the item at the top.
/// See also:
///  * [TimelineSearchWebPage] for web layout.
///  * [TimelineSearchMobilePage] for mobile layout.
class TimelineSearchTabletPage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchTabletPage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineSearchTabletPageState();
}

class TimelineSearchTabletPageState extends State<TimelineSearchTabletPage>
    with TimelineWorkZoneMap {
  final Completer<GoogleMapController> _controller = Completer();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late Size _screenSize;
  final int mapFlex = 5;
  final int contentFlex = 4;
  late double _searchBarWidth;
  late double _contentWidth;
  StreamSubscription? _highlightDelaySubscription;

  int? prevMin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _searchBarWidth =
        _screenSize.width * (mapFlex / (mapFlex + contentFlex) * 0.95);
    _contentWidth =
        _screenSize.width * (contentFlex / (mapFlex + contentFlex) * 0.96);
  }

  @override
  void initState() {
    super.initState();
    _detectCurrentHighlightedItem();
  }

  void _detectCurrentHighlightedItem() {
    itemPositionsListener.itemPositions.addListener(() {
      _highlightDelaySubscription?.cancel();
      int value = itemPositionsListener.itemPositions.value
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace:
                BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
                    builder: (blocContext, state) => Row(children: [
                          TimelineTabletSearchBar(
                            barSize: Size(_searchBarWidth, 35),
                            barMargin: EdgeInsets.only(left: 20, top: 30),
                            displayBackButton: true,
                          ),
                          Spacer()
                        ])),
          )),
      body: Row(children: [
        Flexible(flex: mapFlex, child: buildMap(context, _controller)),
        Flexible(
            flex: contentFlex,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTitleWithBorder(context),
                  Expanded(child: _buildContentBody())
                ]))
      ]));

  Widget _buildTitleWithBorder(BuildContext context) =>
      TimelineSheetHeader(width: _contentWidth);

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
          builder: (blocContext, state) => Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildImageListView(context, state.images)));

  Widget _buildImageListView(
          BuildContext context, List<TimelineImageModel> images) =>
      images.isNotEmpty
          ? ScrollablePositionedList.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).colorScheme.onBackground),
              itemCount: images.length,
              itemBuilder: (context, index) => _buildItem(index, images),
              initialScrollIndex: widget.initialImageIndex,
              itemPositionsListener: itemPositionsListener,
              scrollDirection: Axis.vertical,
            )
          : Container();

  _buildItem(int index, List<TimelineImageModel> images) =>
      images.getOrNull<TimelineImageModel>(index)?.let((image) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getImageWidgets(
                  index, image, images, context, index == prevMin) +
              [TimelinePhotoDownloader()]));

  List<Widget> _getImageWidgets(
          int index,
          TimelineImageModel image,
          List<TimelineImageModel> images,
          BuildContext context,
          bool isHighlighted) =>
      TimelineSearchImageBuilder(image,
              index: index,
              images: images,
              width: _contentWidth,
              isHighlighted: isHighlighted)
          .buildSearchImageCellWidgets(context);
}
