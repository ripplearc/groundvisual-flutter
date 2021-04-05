import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Color the bar rod stack item with dark and light.
class BarRodPalette {
  Color? _dark;
  Color? _light;

  BarRodPalette(BuildContext context) {
    _dark = Theme.of(context).colorScheme.primary;
    _light = Theme.of(context).colorScheme.onSurface;
  }

  BarChartRodData colorBarRod(BarChartRodData rodData) =>
      rodData.copyWith(rodStackItems: _colorStackItem(rodData));

  List<BarChartRodStackItem> _colorStackItem(BarChartRodData rodData) =>
      rodData.rodStackItems.asMap().entries.map((entry) {
        BarChartRodStackItem item = entry.value;
        if (entry.key == 0) {
          return BarChartRodStackItem(
              item.fromY, item.toY, _dark ?? Colors.orange);
        } else if (entry.key == 1) {
          return BarChartRodStackItem(
              item.fromY, item.toY, _light ?? Colors.grey);
        } else {
          return item;
        }
      }).toList();
}
