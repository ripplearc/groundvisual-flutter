import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Use Google map to show the work zone of polygon.
class WorkZoneMap extends StatefulWidget {
  final double bottomPadding;
  final CameraPosition cameraPosition;
  final Set<Polygon> workZone;
  final Set<Polygon> highlightedWorkZone;
  final Completer<GoogleMapController> mapController;

  WorkZoneMap({
    Key? key,
    this.bottomPadding = 0,
    this.cameraPosition =
        const CameraPosition(target: LatLng(37.6, -95.665), zoom: 13),
    this.workZone = const <Polygon>{},
    this.highlightedWorkZone = const <Polygon>{},
    required this.mapController,
  }) : super(key: key);

  @override
  State<WorkZoneMap> createState() => WorkZoneMapState();
}

class WorkZoneMapState extends State<WorkZoneMap> with WidgetsBindingObserver {
  String? _darkMapStyle;
  String? _lightMapStyle;

  WorkZoneMapState();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) => GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: widget.cameraPosition,
      onMapCreated: (GoogleMapController controller) async {
        await Future.delayed(_delayInitialAnimationAndStylingAfterMapCreated);
        widget.mapController.complete(controller);
      },
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      zoomControlsEnabled: false,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
      polygons: _coloredWorkZoneSet);

  Duration get _delayInitialAnimationAndStylingAfterMapCreated =>
      getValueForScreenType(
          context: context,
          mobile: Duration(milliseconds: 500),
          tablet: Duration(milliseconds: 500),
          desktop: Duration(milliseconds: 1000));

  Set<Polygon> get _coloredWorkZoneSet => (widget.workZone
              .map((p) => p.copyWith(
                    strokeColorParam:
                        Theme.of(context).colorScheme.primaryContainer,
                    fillColorParam: Theme.of(context).colorScheme.primary,
                  ))
              .toList() +
          widget.highlightedWorkZone
              .map((p) => p.copyWith(
                    strokeColorParam: Theme.of(context).colorScheme.secondary,
                    fillColorParam:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ))
              .toList())
      .toSet();

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
