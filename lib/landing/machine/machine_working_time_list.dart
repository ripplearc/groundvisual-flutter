import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';

import 'machine_bar_chart_sample.dart';
import 'machine_bar_chart_sample2.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        builder: (context, state) {
      // if (state is ) {
      return _genCard(context);
      // } else {
      //   return _genCard();
      // }
    });
  }

  Card _genCard2(BuildContext context) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: AspectRatio(
                aspectRatio: 4,
                child: Container(
                    height: 72,
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _genOnlineNotification(context),
                        _genMachineLabel(context),
                        Expanded(child: MachineBarChartSample.withRandomData(context))
                        // Expanded(child: Container(width: double.infinity)),
                      ],
                    )))));
  }

  Card _genCard(BuildContext context) {
    return Card(
        child: ListView.builder(
            itemCount: 8,
            // padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                  aspectRatio: 4,
                  child: Container(
                      height: 72,
                      color: Theme.of(context).colorScheme.background,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _genOnlineNotification(context),
                          _genMachineLabel(context),
                          Expanded(
                              child: MachineBarChartSample.withRandomData(context))
                          // Expanded(child: Container(width: double.infinity)),
                        ],
                      )));
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
