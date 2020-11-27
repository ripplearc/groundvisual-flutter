import 'dart:ffi';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkingTimeWeeklyChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WorkingTimeWeeklyChartState();
}

class WorkingTimeWeeklyChartState extends State<WorkingTimeWeeklyChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) =>
                      Theme.of(context).textTheme.bodyText2,
                  margin: 2,
                  getTitles: (double value) {
                    int index = (value + 1).toInt();
                    return (index % 6 == 0) ? index.toString() + ":00" : "";
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  interval: 7,
                  getTextStyles: (value) {
                    return Theme.of(context).textTheme.caption;
                  },
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 2,
              barGroups: getData(context),
            ),
          ),
        ),
      ),
    );
  }

  double _probabilityOfWorking(int time) {
    int morningDistance = time;
    int eveningDistance = (96 - time).abs();
    int distance = min(morningDistance, eveningDistance);
    if ([0, 24, 48, 72, 95].contains(time)) {
      return 0.1;
    } else {
      return pow(distance / 96.0, 4);
    }
  }

  BarChartRodData _genBarChartRodData(Color dark, Color light, int time) {
    Random random = new Random();
    double randomMinutes =
        random.nextDouble() * 15 * _probabilityOfWorking(time);
    double randomPert = random.nextDouble() * 0.5;
    return BarChartRodData(
        y: randomMinutes,
        width: 1.5,
        rodStackItems: [
          BarChartRodStackItem(0, randomMinutes * (1 - randomPert), dark),
          BarChartRodStackItem(
              randomMinutes * (1 - randomPert), randomMinutes, light),
        ],
        borderRadius: const BorderRadius.all(Radius.zero));
  }

  List<BarChartGroupData> getData(BuildContext context) {
    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.onSurface;
    return Iterable<int>.generate(24)
        .map((groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: 2,
            barRods: Iterable<int>.generate(4)
                .map((barId) =>
                    _genBarChartRodData(dark, light, barId + groundId * 4))
                .toList()))
        .toList();
  }
}
