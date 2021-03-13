import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/model/working_time_daily_chart_data.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

/// Generate the data model to display on the trend chart. For one week, it shows
/// week day as the bottom titles. For more than one week, it shows the date at
/// the bottom titles.
/// Each rod contains working and idling time.
@injectable
class WorkingTimeTrendChartViewModel {
  final weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

  final TrendChartBarConverter trendChartBarConverter;

  WorkingTimeTrendChartViewModel(this.trendChartBarConverter);

  Future<WorkingTimeChartData> trendWorkingTime(TrendPeriod period) async {
    final numOfGroup = trendChartBarConverter.numOfGroup(period);
    final daysPerGroup = trendChartBarConverter.daysPerGroup(period);
    double space = 30 / (numOfGroup * daysPerGroup / 7.0);

    final workingTime = _genWorkingTimes(numOfGroup, daysPerGroup);
    final bars = _genRodBars(workingTime, numOfGroup, daysPerGroup, space);
    final tooltips = _genToolTips(workingTime, numOfGroup, daysPerGroup);
    final bottomTitles = _genBottomTitles(numOfGroup, daysPerGroup);

    return WorkingTimeChartData(bars, tooltips, 4.0, space, bottomTitles);
  }

  List<BarChartGroupData> _genRodBars(List<_WorkingTimePerRod> workingTime,
          int numOfGroup, int daysPerGroup, double space) =>
      List.generate(
        numOfGroup,
        (groundId) => BarChartGroupData(
            x: groundId,
            barsSpace: space,
            barRods: _genBarRods(
                workingTime, groundId, numOfGroup, daysPerGroup, space)),
      );

  List<List<String>> _genToolTips(List<_WorkingTimePerRod> workingTime,
          int numOfGroup, int daysPerGroup) =>
      List.generate(
        numOfGroup,
        (groupId) => List.generate(
                daysPerGroup,
                (rodId) =>
                    _genDateToolTip(groupId, rodId, workingTime, daysPerGroup))
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
              (groupId) => DateFormat(' MM/dd ').format(
                  DateTime.now() - Duration(days: groupId * daysPerGroup)))
          .reversed
          .toList();

  List<BarChartRodData> _genBarRods(List<_WorkingTimePerRod> workingTime,
          int groundId, int numOfGroup, int daysPerGroup, double space) =>
      List.generate(
        daysPerGroup,
        (rodId) => _genBarChartRodData(
            workingTime.elementAt(rodId + groundId * daysPerGroup), space),
      );

  String _genDateToolTip(int groupId, int rodId,
      List<_WorkingTimePerRod> workingTime, int daysPerGroup) {
    String date = DateFormat('MM/dd').format(
        DateTime.now() - Duration(days: groupId * daysPerGroup + rodId));

    final time = workingTime.elementAt(rodId + groupId * daysPerGroup);
    return '$date\n' +
        'work: ' +
        time.workingHours.ceil().toString() +
        ' hrs\nidle: ' +
        time.idlingHours.ceil().toString() +
        " hrs";
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

  BarChartRodData _genBarChartRodData(
          _WorkingTimePerRod workingTime, double space) =>
      BarChartRodData(
          y: workingTime.totalHours,
          width: 0.1,
          rodStackItems: [
            BarChartRodStackItem(
                0, workingTime.workingHours, Colors.transparent),
            BarChartRodStackItem(workingTime.workingHours,
                workingTime.totalHours, Colors.transparent),
          ],
          borderRadius: const BorderRadius.all(Radius.zero));
}

/// data model the represents the working and idling time in a day.
class _WorkingTimePerRod {
  double totalHours;
  double workingHours;
  double idlingHours;

  _WorkingTimePerRod(this.totalHours, this.workingHours, this.idlingHours);
}
