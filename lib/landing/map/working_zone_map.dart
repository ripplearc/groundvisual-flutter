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
  Set<Polygon> _polygons = Set();
  Completer<GoogleMapController> _controller = Completer();
  String _darkMapStyle;
  String _lightMapStyle;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.626985, -82.982993),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, WorkingTimeChartTouchState>(
      buildWhen: (previous, current) =>
          current is WorkingTimeChartTouchShowWorkArea,
      builder: (context, state) {
        if (state is WorkingTimeChartTouchShowWorkArea) {
          _polygons = state.workAreas;
        }
        return AspectRatio(
            aspectRatio: 1.8,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              zoomControlsEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              ].toSet(),
              polygons: _polygons,
            ));
      },
    );
  }

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
    //
    // final test = await rootBundle.loadString('assets/mock_response/test.json');
    // final decoded = json.decode(test);
    // final object = SiteWorkZone.fromJson(decoded);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
