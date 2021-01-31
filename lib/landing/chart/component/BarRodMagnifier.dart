import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Highlight the bar rod being selected. It iterates through the group data
/// and find the bar rod with matching group id and rod id. It then changes the
/// width, height and color of the found bar rod for highlight.
class BarRodMagnifier {
  final BuildContext context;
  final double horizontalMagnifier;
  final double verticalMagnifier;

  final touchedBarGroupIndex;
  final touchedRodDataIndex;

  BarRodMagnifier(
      this.context, this.touchedBarGroupIndex, this.touchedRodDataIndex,
      {this.horizontalMagnifier = 2, this.verticalMagnifier = 1.1});

  List<BarChartGroupData> highlightSelectedGroupIfAny(
          List<BarChartGroupData> bars) =>
      bars.asMap().entries.map((entry) {
        if (entry.key == touchedBarGroupIndex) {
          BarChartGroupData groupData = entry.value;
          return BarChartGroupData(
              x: groupData.x,
              barsSpace: groupData.barsSpace,
              barRods: _highlightSelectedBarRodIfAny(groupData));
        } else {
          return entry.value;
        }
      }).toList();

  List<BarChartRodData> _highlightSelectedBarRodIfAny(
          BarChartGroupData groupData) =>
      groupData.barRods.asMap().entries.map((entry) {
        if (entry.key == touchedRodDataIndex) {
          BarChartRodData rodData = entry.value;
          return BarChartRodData(
              y: rodData.y * verticalMagnifier,
              width: rodData.width * horizontalMagnifier,
              borderRadius: rodData.borderRadius,
              rodStackItems: _recolorStackItem(rodData));
        } else {
          return entry.value;
        }
      }).toList();

  List<BarChartRodStackItem> _recolorStackItem(BarChartRodData rodData) =>
      rodData.rodStackItems.asMap().entries.map((entry) {
        BarChartRodStackItem item = entry.value;
        if (entry.key == 0) {
          return BarChartRodStackItem(
              item.fromY * verticalMagnifier,
              item.toY * verticalMagnifier,
              Theme.of(context).colorScheme.primaryVariant);
        } else if (entry.key == 1) {
          return BarChartRodStackItem(item.fromY * verticalMagnifier,
              item.toY * verticalMagnifier, item.color);
        } else {
          return item;
        }
      }).toList();
}
