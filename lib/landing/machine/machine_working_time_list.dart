import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/machine_label.dart';
import 'package:groundvisual_flutter/landing/machine/machine_offline_indication.dart';
import 'package:groundvisual_flutter/landing/machine/machine_online_indication.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'machine_working_time_bar_chart.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        builder: (context, state) => _genCard(context));
  }

  Card _genCard(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text('Machines', style: Theme.of(context).textTheme.headline5),
          subtitle: _genLegend(context),
        ),
        _genCardContent(context)
      ]));

  Row _genLegend(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              color: Theme.of(context).colorScheme.primary,
              width: 60,
              height: 5),
          Spacer(flex: 2),
          Text('working', style: Theme.of(context).textTheme.caption),
          Spacer(flex: 2),
          Container(
              color: Theme.of(context).colorScheme.onSurface,
              width: 60,
              height: 5),
          Spacer(flex: 2),
          Text('idling', style: Theme.of(context).textTheme.caption),
          Spacer(flex: 10),
        ],
      );

  Column _genCardContent(BuildContext context) => Column(
      children:
          List<Container>.generate(4, (index) => _genListItem(context, index)));

  Container _genListItem(BuildContext context, int index) {
    final data = Random().let((random) =>
        UnitWorkingTime(720, random.nextInt(720), random.nextInt(240)));

    return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 96,
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _genMachineLabelWithStatus(context, index % 2 == 0),
            Expanded(child: MachineWorkingTimeChart.withData(data))
          ],
        ));
  }

  Stack _genMachineLabelWithStatus(BuildContext context, bool online) => Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(58, 58))),
          MachineLabel(
              name: "312",
              labelSize: Size(56, 56),
              shadowTopLeftOffset: Size(1, 1)),
          online
              ? MachineOnlineIndication(rightBottomOffset: Size(0, 0))
              : MachineOfflineIndication(offset: Size(0, 0), warning: '21h')
        ],
      );
}
