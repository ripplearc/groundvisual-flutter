import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';

class WorkingZoneMap extends StatefulWidget {
  @override
  State<WorkingZoneMap> createState() => WorkingZoneMapState();
}

class WorkingZoneMapState extends State<WorkingZoneMap>
    with WidgetsBindingObserver {
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
      BlocBuilder<WorkingTimeChartTouchBloc, WorkingTimeChartTouchState>(
          buildWhen: (previous, current) =>
              current is WorkingTimeChartTouchShowWorkArea ||
              current is WorkingTimeChartTouchInitial,
          builder: (context, state) {
            CameraPosition cameraPosition;
            Set<Polygon> workAreas;
            if (state is WorkingTimeChartTouchShowWorkArea) {
              cameraPosition = state.cameraPosition;
              workAreas = state.workAreas;
            } else if (state is WorkingTimeChartTouchInitial) {
              cameraPosition = state.cameraPosition;
            }
            return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: AspectRatio(
                        aspectRatio: 3,
                        child: _genGoogleMap(cameraPosition, workAreas))));
          });

  GoogleMap _genGoogleMap(
          CameraPosition cameraPosition, Set<Polygon> workAreas) =>
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
        polygons: workAreas,
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
