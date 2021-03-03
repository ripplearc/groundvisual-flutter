import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';

/// Color the bar rod stack item with dark and light.
class BarRodPalette {
  Color _dark;
  Color _light;

  BarRodPalette(BuildContext context) {
    _dark = Theme.of(context).colorScheme.primary;
    _light = Theme.of(context).colorScheme.onSurface;
  }

  DailyWorkingTimeDataLoaded colorBarChart(DailyWorkingTimeDataLoaded state) =>
      state.copyWith(
          chartDataParam: state.chartData
              .copyWith(barsParam: _colorBarGroup(state.chartData.bars)));

  List<BarChartGroupData> _colorBarGroup(List<BarChartGroupData> bars) =>
      bars.asMap().entries.map((entry) {
        BarChartGroupData groupData = entry.value;
        return BarChartGroupData(
            x: groupData.x,
            barsSpace: groupData.barsSpace,
            barRods: _colorBarRod(groupData));
      }).toList();

  List<BarChartRodData> _colorBarRod(BarChartGroupData groupData) =>
      groupData.barRods.asMap().entries.map((entry) {
        BarChartRodData rodData = entry.value;
        return BarChartRodData(
            y: rodData.y,
            width: rodData.width,
            borderRadius: rodData.borderRadius,
            rodStackItems: _colorStackItem(rodData));
      }).toList();

  List<BarChartRodStackItem> _colorStackItem(BarChartRodData rodData) =>
      rodData.rodStackItems.asMap().entries.map((entry) {
        BarChartRodStackItem item = entry.value;
        if (entry.key == 0) {
          return BarChartRodStackItem(item.fromY, item.toY, _dark);
        } else if (entry.key == 1) {
          return BarChartRodStackItem(item.fromY, item.toY, _light);
        } else {
          return item;
        }
      }).toList();
}
