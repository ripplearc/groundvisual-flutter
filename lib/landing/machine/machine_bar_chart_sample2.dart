import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:groundvisual_flutter/extensions/color.dart';

class MachineBarChartSample extends StatelessWidget {
  final List<charts.Series> seriesList;

  MachineBarChartSample(this.seriesList);

  factory MachineBarChartSample.withRandomData(BuildContext context) {
    return MachineBarChartSample(_createRandomData(context));
  }

  /// Create random data.
  static List<charts.Series<OrdinalSales, String>> _createRandomData(
      BuildContext context) {
    final random = new Random();

    final data = [
      new OrdinalSales('2014', random.nextInt(100)),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', random.nextInt(25)),
    ];

    return [
      charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          // Set a label accessor to control the text of the bar label.
          // colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
          colorFn: (_, __) =>
              Theme.of(context).colorScheme.primary.toChartColor(),
          labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.year}: \$${sales.sales.toString()}'),
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (OrdinalSales sales, _) =>
            '${sales.year}: \$${sales.sales.toString()}',

        colorFn: (_, __) =>
            Theme.of(context).colorScheme.onSurface.toChartColor(),
        // colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        fillPatternFn: (OrdinalSales sales, _) =>
            charts.FillPatternType.forwardHatch,
      )
    ];
  }

  // EXCLUDE_FROM_GALLERY_DOCS_END

  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    final verticalStaticTicks = <charts.TickSpec<double>>[
      new charts.TickSpec(0),
      new charts.TickSpec(100),
    ];
    return new charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator(
          insideLabelStyleSpec: new charts.TextStyleSpec(
              color: Theme.of(context).colorScheme.onSurface.toChartColor()),
          outsideLabelStyleSpec: new charts.TextStyleSpec(
              color:
                  Theme.of(context).colorScheme.secondary.toChartColor())),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          tickProviderSpec:
              charts.StaticNumericTickProviderSpec(verticalStaticTicks)),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
