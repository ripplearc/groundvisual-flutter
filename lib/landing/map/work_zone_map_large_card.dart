import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:injectable/injectable.dart';

import 'bloc/work_zone_map_bloc.dart';

class WorkZoneMapLargeCard extends StatefulWidget {
  final double bottomPadding;

  const WorkZoneMapLargeCard({Key key, @required this.bottomPadding})
      : super(key: key);

  @override
  State<WorkZoneMapLargeCard> createState() => WorkZoneMapLargeCardState(
      bottomPadding, getIt<CameraAnimationController>());
}

class WorkZoneMapLargeCardState extends State<WorkZoneMapLargeCard>
    with WidgetsBindingObserver {
  final double bottomPadding;
  Completer<GoogleMapController> _controller = Completer();
  String _darkMapStyle;
  String _lightMapStyle;
  final CameraAnimationController _cameraAnimationController;

  WorkZoneMapLargeCardState(
      this.bottomPadding, this._cameraAnimationController);

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
            _animateCameraPosition(state, controller);
          },
          builder: (context, state) => _buildMapCardWithPolygons(state));

  StatelessWidget _buildMapCardWithPolygons(WorkZoneMapState state) {
    if (state is WorkZoneMapPolygons) {
      return _buildMapCard(context, state.cameraPosition, state.workZone);
    } else if (state is WorkZoneMapInitial) {
      return _buildMapCard(context, state.cameraPosition, Set());
    } else {
      return Container();
    }
  }

  void _animateCameraPosition(
      WorkZoneMapState state, GoogleMapController controller) {
    if (state is WorkZoneMapPolygons) {
      _cameraAnimationController
          .executeAnimation(() => controller.animateCamera(
                CameraUpdate.newCameraPosition(state.cameraPosition),
              ));
    }
  }

  Card _buildMapCard(BuildContext context, CameraPosition cameraPosition,
          Set<Polygon> workZone) =>
      Card(
          color: Theme.of(context).colorScheme.background,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: _buildGoogleMap(cameraPosition, workZone));

  GoogleMap _buildGoogleMap(
          CameraPosition cameraPosition, Set<Polygon> workZone) =>
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {});
        },
        padding: EdgeInsets.only(bottom: bottomPadding),
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

@injectable
class CameraAnimationController {
  bool _initialized = false;

  executeAnimation(Function f) async {
    await _delayInitialAnimationForPaddingTakesEffect();
    f();
  }

  Future _delayInitialAnimationForPaddingTakesEffect() async {
    if (!_initialized) {
      await Future.delayed(Duration(seconds: 1));
      _initialized = true;
    }
  }
}
