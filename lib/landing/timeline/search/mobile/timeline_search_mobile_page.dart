import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/drawing/clip_shadow_path.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/images/timeline_search_images_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
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
  Widget? _animatedAppBar;
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
            print("✅ $prevMin");
            BlocProvider.of<TimelineSearchImagesBloc>(context)
                .add(SearchDailyTimeline(Date.today));
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
      body: Stack(children: [_buildMapHeader(context), _buildContent()]));

  PreferredSize _buildAppBar() => PreferredSize(
      preferredSize: Size.fromHeight(150.0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation =
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, -0.0))
                  .animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: _animatedAppBar ?? _buildAppBarInVisualMode(),
      ));

  AppBar _buildAppBarInVisualMode() => AppBar(
        key: ValueKey(1),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
            builder: (blocContext, state) => TimelineSearchBar(
                dateString: state.dateString,
                onTap: () => setState(() {
                      _animatedAppBar = _buildAppBarInSearchMode();
                    }))),
      );

  AppBar _buildAppBarInSearchMode() => AppBar(
      key: ValueKey(2),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 30),
          child: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
              builder: (blocContext, state) =>
                  _buildAppBarSearchModeContent(state))));

  Column _buildAppBarSearchModeContent(TimelineSearchQueryState state) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildSearchModeHeader(), _buildSearchModeBody(state)],
      );

  Container _buildSearchModeBody(TimelineSearchQueryState state) => Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0.5, 0.5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: IntrinsicHeight(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: DateButton(
                  textStyle: Theme.of(context).textTheme.bodyText2,
                  dateText: state.dateString,
                  action: () {})),
          VerticalDivider(
            thickness: 2,
          ),
          Expanded(
              child: DateButton(
                  textStyle: Theme.of(context).textTheme.bodyText2,
                  dateText: "Time",
                  icon: Icon(Icons.calendar_today_outlined, size: 20),
                  action: () {})),
        ],
      )));

  Container _buildSearchModeHeader() => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            _buildExitSearchModeButton(),
            Expanded(
                child: Center(
                    child: Text("Edit your search",
                        style: Theme.of(context).textTheme.headline6))),
            _buildSearchFilterButton()
          ],
        ),
      );

  IconButton _buildExitSearchModeButton() => IconButton(
        onPressed: () => setState(() {
          _animatedAppBar = _buildAppBarInVisualMode();
        }),
        icon: Icon(Icons.close),
        color: Theme.of(context).colorScheme.onBackground,
      );

  IconButton _buildSearchFilterButton() => IconButton(
        onPressed: () {},
        icon: Icon(Icons.filter_list),
        color: Theme.of(context).colorScheme.onBackground,
      );

  Widget _buildMapHeader(BuildContext context) =>
      BlocBuilder<WorkZoneBloc, WorkZoneState>(builder: (context, state) {
        if (state is WorkZoneInitial)
          return WorkZoneMap(
              bottomPadding: _contentHeight,
              cameraPosition: state.cameraPosition,
              mapController: _controller);
        else if (state is WorkZonePolygons)
          return WorkZoneMap(
              bottomPadding: _contentHeight,
              cameraPosition: state.cameraPosition,
              workZone: state.workZone,
              mapController: _controller);
        else
          return WorkZoneMap(
              bottomPadding: _contentHeight, mapController: _controller);
      });

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
      BlocBuilder<TimelineSearchImagesBloc, TimelineSearchImagesState>(
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
              BlocBuilder<TimelineSearchImagesBloc, TimelineSearchImagesState>(
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
