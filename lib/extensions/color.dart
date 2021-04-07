import 'package:flutter/material.dart' as material;
// ignore: import_of_legacy_library_into_null_safe
import 'package:charts_flutter/flutter.dart' as charts;

/// Charts_flutter has its own Color definition, this extension converts the Flutter
/// Color to the Charts_flutter Color
extension ChartColor on material.Color {
  charts.Color toChartColor() {
    return charts.Color(r: red, g: green, b: blue);
  }
}
