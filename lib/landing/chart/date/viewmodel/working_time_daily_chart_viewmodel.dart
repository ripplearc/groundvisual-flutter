import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/date/model/working_time_daily_chart_data.dart';
import 'package:injectable/injectable.dart';

/// Generate the data model to display on the daily chart. It divides
/// into 24 groups with each group having 4 rods which represents 4 quarters.
/// Each rod contains working and idling time.
@injectable
class WorkingTimeDailyChartViewModel {
  int _hoursPerDay = 24;
  int _quartersPerHour = 4;

  Future<WorkingTimeDailyChartData> dailyWorkingTime(
      BuildContext context) async {
    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.onSurface;

    final workingTime = _genWorkingTimes();

    final bars = List.generate(
        _hoursPerDay,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: 1.6,
            barRods: _genBarRods(dark, light, workingTime, groundId)));

    final tooltips = List.generate(
        _hoursPerDay,
        (groupId) => List.generate(_quartersPerHour,
            (rodId) => _genToolTip(groupId, rodId, workingTime, context)));

    final bottomTitles = List.generate(_hoursPerDay, (index) {
      int hour = index + 1;
      hour = hour % _hoursPerDay;
      return (hour % 6 == 0) ? hour.toString() + ":00" : "";
    });

    return WorkingTimeDailyChartData(bars, tooltips, 15, bottomTitles);
  }

  List<BarChartRodData> _genBarRods(Color dark, Color light,
          List<_WorkingTimePerQuarter> workingTime, int groundId) =>
      List.generate(
        _quartersPerHour,
        (rodId) => _genBarChartRodData(
          dark,
          light,
          workingTime.elementAt(rodId + groundId * _quartersPerHour),
        ),
      );

  BarTooltipItem _genToolTip(int groupId, int rodId,
      List<_WorkingTimePerQuarter> workingTime, BuildContext context) {
    String starTimeStamp = groupId.toString() +
        (rodId == 0 ? ":0" : ":") +
        (rodId * 15).toString();
    final time = workingTime.elementAt(rodId + groupId * _quartersPerHour);
    return BarTooltipItem(
        '$starTimeStamp\n' +
            'work: ' +
            time.workingMinutes.toInt().toString() +
            ' mins\nidle: ' +
            time.idlingMinutes.toInt().toString() +
            " mins",
        Theme.of(context)
            .textTheme
            .caption
            .apply(color: Theme.of(context).colorScheme.onBackground));
  }

  List<_WorkingTimePerQuarter> _genWorkingTimes() => List.generate(
      _hoursPerDay * _quartersPerHour,
      (index) => _genWorkingTimePerQuarter(index));

  _WorkingTimePerQuarter _genWorkingTimePerQuarter(int quarterIndex) {
    Random random = new Random();
    double randomMinutes =
        random.nextDouble() * 500 * _probabilityOfWorking(quarterIndex);
    double randomPert = random.nextDouble() * 0.5;
    return _WorkingTimePerQuarter(randomMinutes,
        randomMinutes * (1 - randomPert), randomMinutes * randomPert);
  }

  BarChartRodData _genBarChartRodData(
          Color dark, Color light, _WorkingTimePerQuarter workingTime) =>
      BarChartRodData(
          y: workingTime.totalMinutes,
          width: 1.6,
          rodStackItems: [
            BarChartRodStackItem(0, workingTime.workingMinutes, dark),
            BarChartRodStackItem(
                workingTime.workingMinutes, workingTime.totalMinutes, light),
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

/// data model the represents the working and idling time in 15 minutes
class _WorkingTimePerQuarter {
  double totalMinutes;
  double workingMinutes;
  double idlingMinutes;

  _WorkingTimePerQuarter(
      this.totalMinutes, this.workingMinutes, this.idlingMinutes);
}
