import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_photo_downloader.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_photo_viewer.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_sheet_pullup_header.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';

class TimelineSearchTabletPage extends StatefulWidget {
  final int initialImageIndex;

  const TimelineSearchTabletPage({Key? key, required this.initialImageIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineSearchTabletPageState();
}

class TimelineSearchTabletPageState extends State<TimelineSearchTabletPage> {
  final Completer<GoogleMapController> _controller = Completer();

  late Size _screenSize;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            Text("Location, Time")
          ],
        ),
        body: Row(
          children: [
            Flexible(
                child:
                    WorkZoneMap(bottomPadding: 0, mapController: _controller)),
            Flexible(
              child: Column(children: [
                _buildTitleWithBorder(context),
                _buildContentBody()
              ]),
            )
          ],
        ),
      );

  Widget _buildTitleWithBorder(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
          color: Theme.of(context).colorScheme.background,
          child: TimelineSheetPullUpHeader()));

  Widget _buildContentBody() =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (blocContext, state) => Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: _screenSize.width,
              child: _buildImagePageView(context, state.images)));

  Widget _buildImagePageView(
          BuildContext context, List<TimelineImageModel> images) =>
      images.isNotEmpty
          ? PageView.builder(
              controller: PageController(initialPage: widget.initialImageIndex),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _buildImageViewer(index)),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: TimelinePhotoDownloader(),
                      )
                    ],
                  ))
          : Container();

  Widget _buildImageViewer(int index) =>
      TimelineSearchPhotoViewer(index, width: _screenSize.width * 0.9);
}
