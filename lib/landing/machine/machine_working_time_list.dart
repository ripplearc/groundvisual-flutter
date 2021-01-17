import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/machine_label.dart';
import 'package:groundvisual_flutter/landing/machine/machine_offline_indication.dart';
import 'package:groundvisual_flutter/landing/machine/machine_online_indication.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';
import 'package:groundvisual_flutter/models/machine_unit_working_time.dart';
import 'package:shimmer/shimmer.dart';

import 'machine_working_time_bar_chart.dart';

/// Widget displays the list of the machines and their working hours and online status.
class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _genCard();

  Widget _genCard() => BlocBuilder<MachineStatusBloc, MachineStatusState>(
      builder: (context, state) => Card(
          color: Theme.of(context).colorScheme.background,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: Text('Machines',
                  style: Theme.of(context).textTheme.headline5),
              subtitle: _genLegend(context),
            ),
            _genCardContent(context, state)
          ])));

  Row _genLegend(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            color: Theme.of(context).colorScheme.primary, width: 60, height: 5),
        Spacer(flex: 2),
        Text(' working ', style: Theme.of(context).textTheme.caption),
        Spacer(flex: 2),
        Container(
            color: Theme.of(context).colorScheme.onSurface,
            width: 60,
            height: 5),
        Spacer(flex: 2),
        Text(' idling ', style: Theme.of(context).textTheme.caption),
        Spacer(flex: 10),
      ]);

  Widget _genCardContent(BuildContext context, MachineStatusState state) {
    if (state is MachineStatusOfWorkingTimeAndOnline) {
      return _buildContent(state, context);
    } else {
      return _buildShimmerContent(context);
    }
  }

  Column _buildContent(
          MachineStatusOfWorkingTimeAndOnline state, BuildContext context) =>
      Column(
        children: state.workingTimes.entries
            .map((e) => _genListItem(
                context,
                e.key,
                e.value,
                state.onlineStatuses[e.key] ??
                    Stream.error("No Status Available"),
                false))
            .toList(),
      );

  Widget _buildShimmerContent(BuildContext context) => Column(
      children: List.generate(
          2,
          (index) => _genListItem(
              context,
              "",
              UnitWorkingTime(720, 480, 240),
              Stream.value(MachineOnlineStatus(OnlineStatus.connecting, null)),
              true)).toList());

  Container _genListItem(
          BuildContext context,
          String machineName,
          UnitWorkingTime data,
          Stream<MachineOnlineStatus> onlineStatusStream,
          bool shimming) =>
      Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 96,
          color: Theme.of(context).colorScheme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              shimming
                  ? Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.surface,
                      highlightColor: Theme.of(context).colorScheme.onSurface,
                      child: _genMachineLabelWithStatus(
                          context, machineName, onlineStatusStream))
                  : _genMachineLabelWithStatus(
                      context, machineName, onlineStatusStream),
              Expanded(
                  child: shimming
                      ? Shimmer.fromColors(
                          baseColor: Theme.of(context).colorScheme.surface,
                          highlightColor:
                              Theme.of(context).colorScheme.onSurface,
                          child: MachineWorkingTimeChart.withData(data))
                      : MachineWorkingTimeChart.withData(data))
            ],
          ));

  Stack _genMachineLabelWithStatus(BuildContext context, String machineName,
          Stream<MachineOnlineStatus> onlineStatusStream) =>
      Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(58, 58))),
          MachineLabel(
              name: machineName,
              labelSize: Size(56, 56),
              shadowTopLeftOffset: Size(1, 1)),
          StreamBuilder(
              stream: onlineStatusStream,
              builder: (BuildContext context,
                  AsyncSnapshot<MachineOnlineStatus> snapshot) {
                if (snapshot.hasData) {
                  return _genIndication(snapshot.data, context);
                } else if (snapshot.hasError) {
                  return _genIndication(
                      MachineOnlineStatus(OnlineStatus.unknown, null), context);
                } else {
                  return Container();
                }
              })
        ],
      );

  Widget _genIndication(MachineOnlineStatus status, BuildContext context) {
    switch (status.status) {
      case OnlineStatus.offline:
        return MachineOfflineIndication(
            offset: Size(0, 0), warning: status.offlineFormattedString());
      case OnlineStatus.unknown:
        return MachineOfflineIndication(offset: Size(0, 0), warning: "?!");
      case OnlineStatus.online:
        return MachineOnlineIndication(
            rightBottomOffset: Size(0, 0), shimming: false);
      default:
        return MachineOnlineIndication(
            rightBottomOffset: Size(0, 0), shimming: true);
    }
  }
}
