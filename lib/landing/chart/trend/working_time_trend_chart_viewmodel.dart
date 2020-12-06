import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

/// Generate the data model to display on the trend chart. It divides
/// into 24 groups with each group having 4 rods which represents 4 quarters.
/// Each rod contains working and idling time.
@injectable
class WorkingTimeTrendChartViewModel {
  final weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

  WorkingTimeTrendChartViewModel();

  Future<WorkingTimeChartData> trendWorkingTime(
      BuildContext context, TrendPeriod period) async {
    final groupsAndDays = _groupsAndDays(period);
    final numOfGroup = groupsAndDays.item1;
    final daysPerGroup = groupsAndDays.item2;
    double space = 20 / (numOfGroup * daysPerGroup / 7.0);
    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.onSurface;

    final workingTime = _genWorkingTimes(numOfGroup, daysPerGroup);
    final bars =
        _genRodBars(dark, light, workingTime, numOfGroup, daysPerGroup, space);
    final tooltips =
        _genToolTips(workingTime, context, numOfGroup, daysPerGroup);
    final bottomTitles = _genBottomTitles(numOfGroup, daysPerGroup);

    return WorkingTimeChartData(bars, tooltips, 4.0, space, bottomTitles);
  }

  Tuple2<int, int> _groupsAndDays(TrendPeriod period) {
    switch (period) {
      case TrendPeriod.oneWeek:
        return Tuple2(7, 1);
      case TrendPeriod.twoWeeks:
        return Tuple2(5, 3);
      case TrendPeriod.oneMonth:
        return Tuple2(5, 6);
      case TrendPeriod.twoMonths:
        return Tuple2(5, 12);
    }
  }

  List<BarChartGroupData> _genRodBars(
          Color dark,
          Color light,
          List<_WorkingTimePerRod> workingTime,
          int numOfGroup,
          int daysPerGroup,
          double space) =>
      List.generate(
        numOfGroup,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: space,
            barRods: _genBarRods(dark, light, workingTime, groundId, numOfGroup,
                daysPerGroup, space)),
      );

  List<List<BarTooltipItem>> _genToolTips(List<_WorkingTimePerRod> workingTime,
          BuildContext context, int numOfGroup, int daysPerGroup) =>
      List.generate(
        numOfGroup,
        (groupId) => List.generate(
                daysPerGroup,
                (rodId) => _genDateToolTip(
                    groupId, rodId, workingTime, context, daysPerGroup))
            .reversed
            .toList(),
      ).reversed.toList();

  List<String> _genBottomTitles(int numOfGroup, int daysPerGroup) =>
      numOfGroup * daysPerGroup <= 7
          ? _genBottomTitlesOfDay(numOfGroup)
          : _genBottomTitlesOfDate(numOfGroup, daysPerGroup);

  List<String> _genBottomTitlesOfDay(int numOfGroup) =>
      List.generate(numOfGroup, (groupId) {
        int weekDay =
            DateTime.now().subtract(Duration(days: groupId)).weekday - 1;
        return weekDays.elementAt(weekDay);
      }).reversed.toList();

  List<String> _genBottomTitlesOfDate(int numOfGroup, int daysPerGroup) =>
      List.generate(
              numOfGroup,
              (groupId) => DateFormat(' MM/dd ').format(DateTime.now()
                  .subtract(Duration(days: groupId * daysPerGroup))))
          .reversed
          .toList();

  List<BarChartRodData> _genBarRods(
          Color dark,
          Color light,
          List<_WorkingTimePerRod> workingTime,
          int groundId,
          int numOfGroup,
          int daysPerGroup,
          double space) =>
      List.generate(
        daysPerGroup,
        (rodId) => _genBarChartRodData(dark, light,
            workingTime.elementAt(rodId + groundId * daysPerGroup), space),
      );

  BarTooltipItem _genDateToolTip(
      int groupId,
      int rodId,
      List<_WorkingTimePerRod> workingTime,
      BuildContext context,
      int daysPerGroup) {
    String date = DateFormat('MM/dd').format(DateTime.now()
        .subtract(Duration(days: groupId * daysPerGroup + rodId)));

    final time = workingTime.elementAt(rodId + groupId * daysPerGroup);
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

  List<_WorkingTimePerRod> _genWorkingTimes(int numOfGroup, int daysPerGroup) =>
      List.generate(numOfGroup * daysPerGroup,
              (index) => _genWorkingTimePerRod(index, numOfGroup))
          .reversed
          .toList();

  _WorkingTimePerRod _genWorkingTimePerRod(int quarterIndex, int numOfGroup) {
    Random random = new Random();
    double randomMinutes = random.nextDouble() * 8;
    double randomPert = random.nextDouble() * 0.5;
    return _WorkingTimePerRod(randomMinutes, randomMinutes * (1 - randomPert),
        randomMinutes * randomPert);
  }

  BarChartRodData _genBarChartRodData(Color dark, Color light,
          _WorkingTimePerRod workingTime, double space) =>
      BarChartRodData(
          y: workingTime.totalHours,
          width: space,
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
