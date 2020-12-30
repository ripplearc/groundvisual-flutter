import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/machine_label.dart';
import 'package:groundvisual_flutter/landing/machine/machine_offline_indication.dart';
import 'package:groundvisual_flutter/landing/machine/machine_online_indication.dart';

import 'machine_working_time_bar_chart.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        builder: (context, state) => _genCard(context));
  }

  Card _genCard(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.background,
        child: Column(
            children: List<Container>.generate(
                4, (index) => _genListItem(context, index))),
      );

  Container _genListItem(BuildContext context, int index) => Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 96,
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _genMachineLabelWithStatus(context, index % 2 == 0),
          Expanded(child: MachineWorkingTimeChart.withRandomData(context))
        ],
      ));

  Stack _genMachineLabelWithStatus(BuildContext context, bool online) => Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(58, 58))),
          MachineLabel(
              label: "312", size: Size(56, 56), topLeftOffset: Size(1, 1)),
          online
              ? MachineOnlineIndication(rightBottomOffset: Size(0, 0))
              : MachineOfflineIndication(offset: Size(0, 0))
        ],
      );
}
