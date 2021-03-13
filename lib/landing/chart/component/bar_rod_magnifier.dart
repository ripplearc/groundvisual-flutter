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

  BarRodMagnifier(
      this.horizontalMagnifier, this.verticalMagnifier, this.context);

  BarChartRodData highlightBarRod(BarChartRodData rodData) => rodData.copyWith(
      y: rodData.y * verticalMagnifier,
      width: rodData.width * horizontalMagnifier,
      rodStackItems: _recolorStackItem(rodData, context));

  List<BarChartRodStackItem> _recolorStackItem(
          BarChartRodData rodData, BuildContext context) =>
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
