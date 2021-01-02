import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/machine_label.dart';
import 'package:groundvisual_flutter/landing/machine/machine_offline_indication.dart';
import 'package:groundvisual_flutter/landing/machine/machine_online_indication.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';

import 'machine_working_time_bar_chart.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => getIt<MachineStatusBloc>(), child: _genCard());

  Widget _genCard() => BlocBuilder<MachineStatusBloc, MachineStatusState>(
      buildWhen: (prev, current) => current is WorkingTimeAtSelectedSite,
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

  Column _genCardContent(BuildContext context, MachineStatusState state) {
    if (state is WorkingTimeAtSelectedSite) {
      return Column(
        children: state.workingTimes.entries
            .map((e) => _genListItem(context, e.key, e.value))
            .toList(),
      );
    } else {
      return Column(children: []);
    }
  }

  Container _genListItem(
          BuildContext context, String machineName, UnitWorkingTime data) =>
      Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 96,
          color: Theme.of(context).colorScheme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _genMachineLabelWithStatus(context, machineName, true),
              Expanded(child: MachineWorkingTimeChart.withData(data))
            ],
          ));

  Stack _genMachineLabelWithStatus(
          BuildContext context, String machineName, bool online) =>
      Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(58, 58))),
          MachineLabel(
              name: machineName,
              labelSize: Size(56, 56),
              shadowTopLeftOffset: Size(1, 1)),
          online
              ? MachineOnlineIndication(rightBottomOffset: Size(0, 0))
              : MachineOfflineIndication(offset: Size(0, 0), warning: '21h')
        ],
      );
}
