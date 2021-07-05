import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/component/map/workzone_map.dart';

import 'bloc/work_zone_bloc.dart';

/// Use Google map to show the work zone at date or period.
class WorkZoneMapCard extends StatefulWidget {
  final double bottomPadding;
  final bool showTitle;
  final bool embedInCard;

  WorkZoneMapCard(
      {Key? key,
      this.bottomPadding = 0,
      this.showTitle = true,
      this.embedInCard = true})
      : super(key: key);

  @override
  State<WorkZoneMapCard> createState() => WorkZoneMapCardState();
}

class WorkZoneMapCardState extends State<WorkZoneMapCard> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<WorkZoneBloc, WorkZoneState>(
          listener: (context, state) async {
            final controller = await _controller.future;
            _animateCameraPosition(state, controller);
          },
          builder: (context, state) => _buildMapCardWithPolygons(state));

  Widget _buildMapCardWithPolygons(WorkZoneState state) {
    if (state is WorkZonePolygons) {
      return _buildMapCard(context, state.cameraPosition, state.workZone,
          state.highlightedWorkZone);
    } else if (state is WorkZoneInitial) {
      return _buildMapCard(context, state.cameraPosition, Set(), Set());
    } else {
      return Container();
    }
  }

  void _animateCameraPosition(
      WorkZoneState state, GoogleMapController controller) {
    if (state is WorkZonePolygons) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(state.cameraPosition),
      );
    }
  }

  Widget _buildMapCard(BuildContext context, CameraPosition cameraPosition,
          Set<Polygon> workZone, Set<Polygon> highlightedWorkZone) =>
      widget.embedInCard
          ? Card(
              color: Theme.of(context).colorScheme.background,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: _buildCardContent(
                  context, cameraPosition, workZone, highlightedWorkZone))
          : _buildCardContent(
              context, cameraPosition, workZone, highlightedWorkZone);

  Widget _buildCardContent(BuildContext context, CameraPosition cameraPosition,
          Set<Polygon> workZone, Set<Polygon> highlightedWorkZone) =>
      widget.showTitle
          ? Column(mainAxisSize: MainAxisSize.max, children: [
              _buildTitle(context),
              _buildGoogleMap(cameraPosition, workZone, highlightedWorkZone)
            ])
          : _buildGoogleMap(cameraPosition, workZone, highlightedWorkZone);

  ListTile _buildTitle(BuildContext context) => ListTile(
      title: Text('Work Zone', style: Theme.of(context).textTheme.subtitle1));

  WorkZoneMap _buildGoogleMap(CameraPosition cameraPosition,
          Set<Polygon> workZone, Set<Polygon> highlightedWorkZone) =>
      WorkZoneMap(
        bottomPadding: widget.bottomPadding,
        cameraPosition: cameraPosition,
        workZone: workZone,
        highlightedWorkZone: highlightedWorkZone,
        mapController: _controller,
      );
}
