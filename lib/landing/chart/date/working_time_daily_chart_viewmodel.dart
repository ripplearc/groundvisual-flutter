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

  static const nominalSpace = 0.1;

  WorkingTimeDailyChartViewModel(this.dailyChartBarConverter);

  Future<WorkingTimeChartData> dailyWorkingTime() async {
    final workingTime = _genWorkingTimes();

    final bars = List.generate(
        dailyChartBarConverter.groupsPerDay,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: nominalSpace,
            barRods: _genBarRods(workingTime, groundId)));

    final tooltips = List.generate(
        dailyChartBarConverter.groupsPerDay,
        (groupId) => List.generate(dailyChartBarConverter.rodsPerGroup,
            (rodId) => _genToolTip(groupId, rodId, workingTime)));

    final bottomTitles =
        List.generate(dailyChartBarConverter.groupsPerDay, (index) {
      int hour = index + 1;
      hour = hour % dailyChartBarConverter.groupsPerDay;
      return (hour % 6 == 0 && hour != 0) ? hour.toString() + ":00" : "";
    });

    return WorkingTimeChartData(
        bars: bars,
        tooltips: tooltips,
        leftTitleInterval: 15,
        bottomTitles: bottomTitles);
  }

  List<BarChartRodData> _genBarRods(
          List<UnitWorkingTime> workingTime, int groundId) =>
      List.generate(
        dailyChartBarConverter.rodsPerGroup,
        (rodId) => _genBarChartRodData(
          Colors.transparent,
          Colors.transparent,
          workingTime.elementAt(
              rodId + groundId * dailyChartBarConverter.rodsPerGroup),
        ),
      );

  String _genToolTip(
      int groupId, int rodId, List<UnitWorkingTime> workingTime) {
    String starTimeStamp = groupId.toString() +
        (rodId == 0 ? ":0" : ":") +
        (rodId * 15).toString();
    final time = workingTime
        .elementAt(rodId + groupId * dailyChartBarConverter.rodsPerGroup);
    return '$starTimeStamp\n' +
        'work: ' +
        time.workingInSeconds.toInt().toString() +
        ' mins\nidle: ' +
        time.idlingInSeconds.toInt().toString() +
        " mins";
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
          width: nominalSpace,
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
      return pow(distance / 96.0, 4) as double;
    }
  }
}
