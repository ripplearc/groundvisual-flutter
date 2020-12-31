import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/color.dart';
import 'package:groundvisual_flutter/models/UnitWorkingTime.dart';

class MachineWorkingTimeChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  MachineWorkingTimeChart(this.seriesList);

  factory MachineWorkingTimeChart.withRandomData(BuildContext context) {
    return MachineWorkingTimeChart(_createRandomData(context));
  }

  static List<charts.Series<UnitWorkingTime, String>> _createRandomData(
      BuildContext context) {
    final random = new Random();

    final data = [
      new UnitWorkingTime(1440, random.nextInt(720), random.nextInt(240)),
    ];

    return [
      charts.Series<UnitWorkingTime, String>(
        id: 'Working',
        domainFn: (UnitWorkingTime timer, _) => '2020',
        measureFn: (UnitWorkingTime timer, _) => timer.workingInMinutes,
        data: data,
        // Set a label accessor to control the text of the bar label.
        colorFn: (_, __) =>
            Theme.of(context).colorScheme.primary.toChartColor(),
        labelAccessorFn: (UnitWorkingTime timer, _) =>
            timer.workingInFormattedHours(),
      ),
      charts.Series<UnitWorkingTime, String>(
        id: 'Idling',
        domainFn: (UnitWorkingTime timer, _) => "2020",
        measureFn: (UnitWorkingTime timer, _) => timer.idlingInMinutes,
        data: data,
        labelAccessorFn: (UnitWorkingTime timer, _) =>
            timer.idlingInFormattedHours(),
        colorFn: (_, __) =>
            Theme.of(context).colorScheme.onSurface.toChartColor(),
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
      new charts.TickSpec(720),
    ];
    return new charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator(
          insideLabelStyleSpec: new charts.TextStyleSpec(
              color: Theme.of(context).colorScheme.background.toChartColor()),
          outsideLabelStyleSpec: new charts.TextStyleSpec(
              color:
                  Theme.of(context).colorScheme.onBackground.toChartColor())),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          tickProviderSpec:
              charts.StaticNumericTickProviderSpec(verticalStaticTicks)),
    );
  }
}
