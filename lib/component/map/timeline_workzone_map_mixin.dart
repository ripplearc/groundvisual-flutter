import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_bloc.dart';

/// [WorkZoneMapBuilder] displays the [WorkZoneMap] in the timeline search pages
/// , and reacts to [WorkZoneBloc] update such as refreshing based on [WorkZonePolygons]'s
/// [cameraPosition] and [workZone].
mixin WorkZoneMapBuilder {
  Widget buildMap(
          BuildContext context, Completer<GoogleMapController> controller,
          {double bottomPadding = 0}) =>
      BlocConsumer<WorkZoneBloc, WorkZoneState>(
          listener: (context, state) async {
        final ctrl = await controller.future;
        _animateCameraPosition(state, ctrl);
      }, builder: (context, state) {
        if (state is WorkZoneInitial)
          return WorkZoneMap(
              bottomPadding: bottomPadding,
              cameraPosition: state.cameraPosition,
              mapController: controller);
        else if (state is WorkZonePolygons)
          return WorkZoneMap(
              bottomPadding: bottomPadding,
              cameraPosition: state.cameraPosition,
              workZone: state.workZone,
              highlightedWorkZone: state.highlightedWorkZone,
              mapController: controller);
        else
          return WorkZoneMap(
              bottomPadding: bottomPadding, mapController: controller);
      });

  void _animateCameraPosition(
      WorkZoneState state, GoogleMapController controller) {
    if (state is WorkZonePolygons) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(state.cameraPosition),
      );
    }
  }
}
