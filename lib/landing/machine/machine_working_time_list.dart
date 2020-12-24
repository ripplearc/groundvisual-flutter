import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groundvisual_flutter/landing/bloc/chart_touch/working_time_chart_touch_bloc.dart';

class MachineWorkingTimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingTimeChartTouchBloc, SiteSnapShotState>(
        buildWhen: (previous, current) => current is SiteSnapShotThumbnail,
        builder: (context, state) {
          if (state is SiteSnapShotThumbnail) {
            print(state.groupId.toString() + "🎃");
            return _genCard(itemCount: state.groupId);
          } else {
            return _genCard(itemCount: 1);
          }
        });
  }

  Card _genCard({int itemCount = 6}) {
    return Card(
        child: ListView.builder(
            itemCount: itemCount,
            padding: const EdgeInsets.all(8),
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
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.green,
                      ),
                      ClipOval(
                        child: Container(
                          height: 56.0,
                          width: 56.0,
                          alignment: Alignment.center,
                          color: Theme.of(context).colorScheme.surface,
                          child: Text(
                            "321",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1.apply(
                                color:
                                    Theme.of(context).colorScheme.primaryVariant),
                          ),
                        ),
                      ),
                      // Expanded(child: Container(width: double.infinity)),
                    ],
                  ));
            }));
  }
}
