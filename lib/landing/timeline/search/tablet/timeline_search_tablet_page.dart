import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_bar.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TimelineSearchTabletPage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchTabletPage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineSearchTabletPageState();
}

class TimelineSearchTabletPageState extends State<TimelineSearchTabletPage> {
  final Completer<GoogleMapController> _controller = Completer();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final ItemScrollController itemScrollController = ItemScrollController();
  late Size _screenSize;
  final int mapFlex = 5;
  final int contentFlex = 4;
  late double _searchBarWidth;
  late double _photoWidth;

  int? prevMin;
  int? min;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _searchBarWidth =
        _screenSize.width * (mapFlex / (mapFlex + contentFlex) * 0.96);
    _photoWidth =
        _screenSize.width * (contentFlex / (mapFlex + contentFlex) * 0.96);
  }

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
      int value = itemPositionsListener.itemPositions.value
          .where(this._itemIsAtLeastHalfVisible)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;

      if (value != prevMin) {
        setState(() {
          prevMin = value;
        });
      }
    });
  }

  bool _itemIsAtLeastHalfVisible(ItemPosition position) =>
      position.itemTrailingEdge > 0 &&
      position.itemLeadingEdge.abs() < position.itemTrailingEdge.abs();

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TimelineSearchBar(width: _searchBarWidth),
        centerTitle: false,
      ),
      body: Row(children: [
        Flexible(
            flex: 5,
            child: WorkZoneMap(bottomPadding: 0, mapController: _controller)),
        Flexible(
            flex: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTitleWithBorder(context),
                  _buildContentBody()
                ]))
      ]));

  Widget _buildTitleWithBorder(BuildContext context) => Text(
        "7:00 AM ~ 3:00 PM",
        style: Theme.of(context).textTheme.headline6,
      );

  Widget _buildContentBody() =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (blocContext, state) => Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: _screenSize.height - 80,
              child: _buildImagePageView(context, state.images)));

  Widget _buildImagePageView(
          BuildContext context, List<TimelineImageModel> images) =>
      images.isNotEmpty
          ? ScrollablePositionedList.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).colorScheme.onBackground),
              itemCount: images.length,
              itemBuilder: (context, index) => _buildItem(index),
              initialScrollIndex: widget.initialImageIndex,
              itemPositionsListener: itemPositionsListener,
              scrollDirection: Axis.vertical,
            )
          : Container();

  BlocBuilder<TimelineSearchBloc, TimelineSearchState> _buildItem(int index) =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (context, state) =>
              state.images.getOrNull<TimelineImageModel>(index)?.let((image) =>
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildImageViewer(index, image, state.images,
                              context, index == prevMin) +
                          [TimelinePhotoDownloader()])) ??
              Container());

  List<Widget> _buildImageViewer(
          int index,
          TimelineImageModel image,
          List<TimelineImageModel> images,
          BuildContext context,
          bool isHighlighted) =>
      TimelineSearchImageBuilder(image,
              index: index,
              images: images,
              width: _photoWidth,
              isHighlighted: isHighlighted)
          .buildSearchImageCellWidgets(context);
}
