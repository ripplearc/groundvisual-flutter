import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';

import 'machine_working_time_bar_chart.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        builder: (context, state) => _genCard(context));
  }

  Card _genCard(BuildContext context) {
    return Card(
        child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                  aspectRatio: 4,
                  child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 72,
                      color: Theme.of(context).colorScheme.background,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _genMachineLabel(context, index % 2 == 0),
                          Expanded(
                              child:
                                  MachineWorkingTimeChart.withRandomData(context))
                        ],
                      )));
            }));
  }

  Stack _genMachineLabel(BuildContext context, bool online) => Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(60, 60))),
          _genOffset(context, Size(56, 56), Size(1, 1)),
          _genForeground(context, Size(56, 56), "312"),
          online
              ? _genOnlineNotification(context)
              : _genOfflineNotification(context)
        ],
      );

  Positioned _genOnlineNotification(BuildContext context) => Positioned(
      bottom: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 20,
            color: Theme.of(context).colorScheme.background,
          ),
          Icon(
            Icons.circle,
            size: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ));

  Positioned _genOfflineNotification(BuildContext context) => Positioned(
      bottom: 0,
      right: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 32,
            height: 21,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(7))),
          ),
          Container(
            width: 27,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Text(
              '20h',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .overline
                  .apply(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ));

  Positioned _genOffset(BuildContext context, Size size, Size offset) =>
      Positioned(
          left: offset.width,
          top: offset.height,
          child: ClipOval(
            child: Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.primary,
            ),
          ));

  ClipOval _genForeground(BuildContext context, Size size, String label) =>
      ClipOval(
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
}
