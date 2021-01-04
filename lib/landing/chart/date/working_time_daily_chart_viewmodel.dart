import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:groundvisual_flutter/models/machine_unit_working_time.dart';
import 'package:injectable/injectable.dart';

/// Generate the data model to display on the daily chart, based on
/// the configuration given by the DailyChartBarConverter.
/// Each rod contains working and idling time.
@injectable
class WorkingTimeDailyChartViewModel {
  final DailyChartBarConverter dailyChartBarConverter;
  double _space = 1.4;

  WorkingTimeDailyChartViewModel(this.dailyChartBarConverter);

  Future<WorkingTimeChartData> dailyWorkingTime(BuildContext context) async {
    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.onSurface;

    final workingTime = _genWorkingTimes();

    final bars = List.generate(
        dailyChartBarConverter.groupsPerDay,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: 1.6,
            barRods: _genBarRods(dark, light, workingTime, groundId)));

    final tooltips = List.generate(
        dailyChartBarConverter.groupsPerDay,
        (groupId) => List.generate(dailyChartBarConverter.rodsPerGroup,
            (rodId) => _genToolTip(groupId, rodId, workingTime, context)));

    final bottomTitles =
        List.generate(dailyChartBarConverter.groupsPerDay, (index) {
      int hour = index + 1;
      hour = hour % dailyChartBarConverter.groupsPerDay;
      return (hour % 6 == 0) ? hour.toString() + ":00" : "";
    });

    return WorkingTimeChartData(bars, tooltips, 15, _space, bottomTitles);
  }

  List<BarChartRodData> _genBarRods(Color dark, Color light,
          List<UnitWorkingTime> workingTime, int groundId) =>
      List.generate(
        dailyChartBarConverter.rodsPerGroup,
        (rodId) => _genBarChartRodData(
          dark,
          light,
          workingTime.elementAt(
              rodId + groundId * dailyChartBarConverter.rodsPerGroup),
        ),
      );

  BarTooltipItem _genToolTip(int groupId, int rodId,
      List<UnitWorkingTime> workingTime, BuildContext context) {
    String starTimeStamp = groupId.toString() +
        (rodId == 0 ? ":0" : ":") +
        (rodId * 15).toString();
    final time = workingTime
        .elementAt(rodId + groupId * dailyChartBarConverter.rodsPerGroup);
    return BarTooltipItem(
        '$starTimeStamp\n' +
            'work: ' +
            time.workingInSeconds.toInt().toString() +
            ' mins\nidle: ' +
            time.idlingInSeconds.toInt().toString() +
            " mins",
        Theme.of(context)
            .textTheme
            .caption
            .apply(color: Theme.of(context).colorScheme.onBackground));
  }

  List<UnitWorkingTime> _genWorkingTimes() => List.generate(
      dailyChartBarConverter.rodsPerDay,
      (index) => _genWorkingTimePerQuarter(index));

  UnitWorkingTime _genWorkingTimePerQuarter(int quarterIndex) {
    Random random = new Random();
    double randomMinutes =
        random.nextDouble() * 500 * _probabilityOfWorking(quarterIndex);
    double randomPert = random.nextDouble() * 0.5;
    return UnitWorkingTime(
        randomMinutes.toInt(),
        (randomMinutes * (1 - randomPert)).toInt(),
        (randomMinutes * randomPert).toInt());
  }

  BarChartRodData _genBarChartRodData(
          Color dark, Color light, UnitWorkingTime workingTime) =>
      BarChartRodData(
          y: workingTime.durationInSeconds.toDouble(),
          width: 1.6,
          rodStackItems: [
            BarChartRodStackItem(
                0, workingTime.workingInSeconds.toDouble(), dark),
            BarChartRodStackItem(workingTime.workingInSeconds.toDouble(),
                workingTime.durationInSeconds.toDouble(), light),
          ],
          borderRadius: const BorderRadius.all(Radius.zero));

  double _probabilityOfWorking(int time) {
    int morningDistance = time;
    int eveningDistance = (96 - time).abs();
    int distance = min(morningDistance, eveningDistance);
    if ([].contains(time)) {
      return 0.1;
    } else {
      return pow(distance / 96.0, 4);
    }
  }
}
