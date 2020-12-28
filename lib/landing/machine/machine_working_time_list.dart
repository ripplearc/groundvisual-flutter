import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';

import 'machine_bar_chart_sample.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        buildWhen: (previous, current) => current is SiteSnapShotThumbnail,
        builder: (context, state) {
          if (state is SiteSnapShotThumbnail) {
            return _genCard();
          } else {
            return _genCard();
          }
        });
  }

  Card _genCard() {
    return Card(
        child: ListView.builder(
            itemCount: 1,
            // padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 72,
                  color: Theme.of(context).colorScheme.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _genOnlineNotification(context),
                      _genMachineLabel(context),
                      MachineBarChartSample()
                      // Expanded(child: Container(width: double.infinity)),
                    ],
                  ));
            }));
  }

  Stack _genMachineLabel(BuildContext context) => Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(57, 57))),
          _genOffset(context, Size(56, 56), Size(1, 1)),
          _genForeground(context, Size(56, 56), "312"),
        ],
      );

  Icon _genOnlineNotification(BuildContext context) => Icon(
        Icons.circle,
        size: 10,
        color: Theme.of(context).colorScheme.secondary,
      );

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
