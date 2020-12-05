import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Generate the data model to display on the daily chart. It divides
/// into 24 groups with each group having 4 rods which represents 4 quarters.
/// Each rod contains working and idling time.
@injectable
class WorkingTimeTrendChartViewModel {
  int _groups = 7;
  int _daysPerGroup = 1;
  final weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

  Future<WorkingTimeChartData> trendWorkingTime(BuildContext context) async {
    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.onSurface;

    final workingTime = _genWorkingTimes();

    final bars = List.generate(
        _groups,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: 24,
            barRods: _genBarRods(dark, light, workingTime, groundId)));

    final tooltips = List.generate(
        _groups,
        (groupId) => List.generate(_daysPerGroup,
            (rodId) => _genToolTip(groupId, rodId, workingTime, context))).reversed.toList();

    final bottomTitles = List.generate(
      _groups,
      (index) {
        final weekday =
            DateTime.now().subtract(Duration(days: index)).weekday - 1;
        return weekDays.elementAt(weekday);
      },
    ).reversed.toList();

    return WorkingTimeChartData(bars, tooltips, 4.0, bottomTitles);
  }

  List<BarChartRodData> _genBarRods(Color dark, Color light,
          List<_WorkingTimePerRod> workingTime, int groundId) =>
      List.generate(
        _daysPerGroup,
        (rodId) => _genBarChartRodData(
          dark,
          light,
          workingTime.elementAt(rodId + groundId * _daysPerGroup),
        ),
      );

  BarTooltipItem _genToolTip(int groupId, int rodId,
      List<_WorkingTimePerRod> workingTime, BuildContext context) {
    String date = DateFormat('MM/dd').format(DateTime.now()
        .subtract(Duration(days: groupId * _daysPerGroup + rodId)));

    final time = workingTime.elementAt(rodId + groupId * _daysPerGroup);
    return BarTooltipItem(
        '$date\n' +
            'work: ' +
            time.workingHours.ceil().toString() +
            ' hrs\nidle: ' +
            time.idlingHours.ceil().toString() +
            " hrs",
        Theme.of(context)
            .textTheme
            .caption
            .apply(color: Theme.of(context).colorScheme.onBackground));
  }

  List<_WorkingTimePerRod> _genWorkingTimes() => List.generate(
          _groups * _daysPerGroup, (index) => _genWorkingTimePerRod(index))
      .reversed
      .toList();

  _WorkingTimePerRod _genWorkingTimePerRod(int quarterIndex) {
    Random random = new Random();
    double randomMinutes = random.nextDouble() * _daysPerGroup * 8;
    double randomPert = random.nextDouble() * 0.5;
    return _WorkingTimePerRod(randomMinutes, randomMinutes * (1 - randomPert),
        randomMinutes * randomPert);
  }

  BarChartRodData _genBarChartRodData(
          Color dark, Color light, _WorkingTimePerRod workingTime) =>
      BarChartRodData(
          y: workingTime.totalHours,
          width: 24,
          rodStackItems: [
            BarChartRodStackItem(0, workingTime.workingHours, dark),
            BarChartRodStackItem(
                workingTime.workingHours, workingTime.totalHours, light),
          ],
          borderRadius: const BorderRadius.all(Radius.zero));
}

/// data model the represents the working and idling time in 15 minutes
class _WorkingTimePerRod {
  double totalHours;
  double workingHours;
  double idlingHours;

  _WorkingTimePerRod(this.totalHours, this.workingHours, this.idlingHours);
}
