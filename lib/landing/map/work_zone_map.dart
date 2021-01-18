import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';

/// Widget displaying the work zone with polygon.
class WorkZoneMapCard extends StatefulWidget {
  @override
  State<WorkZoneMapCard> createState() => WorkZoneMapCardState();
}

class WorkZoneMapCardState extends State<WorkZoneMapCard> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  String _darkMapStyle;
  String _lightMapStyle;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<WorkZoneMapBloc, WorkZoneMapState>(
          listener: (context, state) async {
            final controller = await _controller.future;
            if (state is WorkZoneMapPolygons) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(state.cameraPosition),
              );
            } else if (state is WorkZoneMapInitial) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(state.cameraPosition),
              );
            }
          },
          builder: (context, state) {
            if (state is WorkZoneMapPolygons) {
              return _genMapCard(context, state.cameraPosition, state.workZone);
            } else if (state is WorkZoneMapInitial) {
              return _genMapCard(context, state.cameraPosition, Set());
            } else {
              return Container();
            }
          });

  Card _genMapCard(BuildContext context, CameraPosition cameraPosition,
          Set<Polygon> workZone) =>
      Card(
          color: Theme.of(context).colorScheme.background,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: Text('Work Zone',
                  style: Theme.of(context).textTheme.headline5),
            ),
            _genMapContent(context, cameraPosition, workZone)
          ]));

  Padding _genMapContent(BuildContext context, CameraPosition cameraPosition,
          Set<Polygon> workZone) =>
      Padding(
          padding: const EdgeInsets.all(0.0),
          child: AspectRatio(
              aspectRatio: 3, child: _genGoogleMap(cameraPosition, workZone)));

  GoogleMap _genGoogleMap(
          CameraPosition cameraPosition, Set<Polygon> workZone) =>
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: false,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        ].toSet(),
        polygons: workZone,
      );

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  @override
  void didChangePlatformBrightness() {
    _setMapStyle();
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
