import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Use Google map to show the work zone of polygon.
class WorkZoneMap extends StatefulWidget {
  final double bottomPadding;
  final CameraPosition cameraPosition;
  final Set<Polygon> workZone;
  final Completer<GoogleMapController> mapController;

  WorkZoneMap(
      {Key? key,
      this.bottomPadding = 0,
      this.cameraPosition =
          const CameraPosition(target: LatLng(37.6, -95.665), zoom: 13),
      this.workZone = const <Polygon>{},
      required this.mapController})
      : super(key: key);

  @override
  State<WorkZoneMap> createState() => WorkZoneMapState();
}

class WorkZoneMapState extends State<WorkZoneMap> with WidgetsBindingObserver {
  static const Duration delayInitialAnimationAndStylingAfterMapCreated =
      Duration(milliseconds: 500);
  String? _darkMapStyle;
  String? _lightMapStyle;

  WorkZoneMapState();

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _loadMapStyles();
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) => GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: widget.cameraPosition,
      onMapCreated: (GoogleMapController controller) async {
        await Future.delayed(delayInitialAnimationAndStylingAfterMapCreated);
        widget.mapController.complete(controller);
      },
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      zoomControlsEnabled: false,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
      polygons: widget.workZone
          .map((p) => p.copyWith(
                strokeColorParam: Theme.of(context).colorScheme.primaryVariant,
                fillColorParam: Theme.of(context).colorScheme.primary,
              ))
          .toSet());

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
    final controller = await widget.mapController.future;
    final theme = WidgetsBinding.instance?.window.platformBrightness;
    if (theme == Brightness.dark)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
