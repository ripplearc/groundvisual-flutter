import 'package:flutter/material.dart' as material;
import 'package:charts_flutter/flutter.dart' as charts;

extension ChartColor on material.Color {
  charts.Color toChartColor() {
    return charts.Color(r: red, g: green, b: blue);
  }
}
