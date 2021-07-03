import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/images/timeline_search_images_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_visual_search_bar.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_sheet_header.dart';
import 'package:groundvisual_flutter/landing/timeline/search/tablet/timeline_tablet_search_bar.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// [TimelineSearchWebPage] is the search page optimized for the web layout.
/// [initialImageIndex] is the one being displayed at the top of viewport when the
/// search page is first loaded.
/// The web page highlights the item with the mouse hover over.
/// See also:
///  * [TimelineSearchTabletPage] for tablet layout.
///  * [TimelineSearchMobilePage] for mobile layout.
class TimelineSearchWebPage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchWebPage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineSearchWebPageState();
}

class TimelineSearchWebPageState extends State<TimelineSearchWebPage> {
  final Completer<GoogleMapController> _controller = Completer();

  late Size _screenSize;
  final int mapFlex = 5;
  final int contentFlex = 4;
  late double _searchBarWidth;
  late double _contentWidth;

  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _searchBarWidth = _screenSize.width * 0.4;
    _contentWidth =
        _screenSize.width * (contentFlex / (mapFlex + contentFlex) * 0.96);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            flexibleSpace: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Image(
                          image: AssetImage('icon/logo.png'),
                          color: Theme.of(context).colorScheme.primary),
                    )),
                Center(
                    child: TimelineTabletSearchBar(
                        barSize: Size(_searchBarWidth, 45)))
              ],
            )),
      ),
      body: Row(children: [
        Flexible(
            flex: mapFlex,
            child: WorkZoneMap(bottomPadding: 0, mapController: _controller)),
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
      BlocBuilder<TimelineSearchImagesBloc, TimelineSearchImagesState>(
          builder: (blocContext, state) => Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: _screenSize.height - 80,
              child: _buildImageListView(context, state.images)));

  Widget _buildImageListView(
          BuildContext context, List<TimelineImageModel> images) =>
      images.isNotEmpty
          ? ScrollablePositionedList.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).colorScheme.onBackground),
              itemCount: images.length,
              itemBuilder: (context, index) => _buildItem(index),
              initialScrollIndex: widget.initialImageIndex,
              scrollDirection: Axis.vertical,
            )
          : Container();

  Widget _buildItem(int index) =>
      _highlightItemWhenHover(_buildItemContent(index), index);

  MouseRegion _highlightItemWhenHover(Widget child, int index) {
    StreamSubscription? highlightSubscription;
    final highlightDelayDuringScrolling = Duration(milliseconds: 180);
    return MouseRegion(
        onExit: (_) => highlightSubscription?.cancel(),
        onEnter: (_) {
          highlightSubscription = Future.delayed(highlightDelayDuringScrolling)
              .asStream()
              .listen((_) => setState(() {
                    _selectedIndex = index;
                  }));
        },
        child: child);
  }

  Widget _buildItemContent(int index) {
    final imageFlex = 4;
    final accessoryFlex = 3;
    final imageWidth = _contentWidth * 4 / 7;
    return BlocBuilder<TimelineSearchImagesBloc, TimelineSearchImagesState>(
        builder: (context, state) => state.images[index].let((image) {
              final viewer = _getImageWidgets(index, image, state.images,
                  imageWidth, context, index == _selectedIndex);
              return Container(
                  height: 280,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: imageFlex,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: viewer[0])),
                        Flexible(
                            flex: accessoryFlex,
                            child: _buildItemAccessories(viewer[1]))
                      ]));
            }));
  }

  Padding _buildItemAccessories(Widget accessory) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimelinePhotoDownloader(),
            Spacer(),
            accessory,
          ]));

  List<Widget> _getImageWidgets(
          int index,
          TimelineImageModel image,
          List<TimelineImageModel> images,
          double imageWidth,
          BuildContext context,
          bool isHighlighted) =>
      TimelineSearchImageBuilder(image,
              index: index,
              images: images,
              width: imageWidth,
              isHighlighted: isHighlighted)
          .buildSearchImageCellWidgets(context);
}
