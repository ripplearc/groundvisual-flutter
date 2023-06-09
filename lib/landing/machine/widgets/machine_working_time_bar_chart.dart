// ignore: import_of_legacy_library_into_null_safe
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/extensions/color.dart';
import 'package:groundvisual_flutter/models/machine_unit_working_time.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// A bar chart with only one domain, one tick on the x axis, to display
/// the working and idling time for a machine.
class MachineWorkingTimeChart extends StatelessWidget {
  final List<charts.TickSpec<int>> scale;
  final UnitWorkingTime data;

  const MachineWorkingTimeChart._({Key? key, required this.scale, required this.data})
      : super(key: key);

  factory MachineWorkingTimeChart.withData(UnitWorkingTime data) => [
        charts.TickSpec(0),
        charts.TickSpec(data.durationInSeconds),
      ].let((ticks) => MachineWorkingTimeChart._(scale: ticks, data: data));

  @override
  Widget build(BuildContext context) => charts.BarChart(
        _createSeries(context),
        vertical: false,
        barRendererDecorator: _genAnnotationTextStyle(context),
        domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
        primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.NoneRenderSpec(),
            tickProviderSpec: charts.StaticNumericTickProviderSpec(scale)),
      );

  charts.BarLabelDecorator<String> _genAnnotationTextStyle(BuildContext context) =>
      charts.BarLabelDecorator(
          insideLabelStyleSpec: new charts.TextStyleSpec(
              color: Theme.of(context).colorScheme.background.toChartColor()),
          outsideLabelStyleSpec: new charts.TextStyleSpec(
              color:
                  Theme.of(context).colorScheme.onBackground.toChartColor()));

  List<charts.Series<UnitWorkingTime, String>> _createSeries(
          BuildContext context) =>
      [
        charts.Series<UnitWorkingTime, String>(
          id: 'Working',
          domainFn: (UnitWorkingTime timer, _) => '',
          measureFn: (UnitWorkingTime timer, _) => timer.workingInSeconds,
          data: [data],
          colorFn: (_, __) =>
              Theme.of(context).colorScheme.primary.toChartColor(),
          labelAccessorFn: (UnitWorkingTime timer, _) =>
              timer.workingInFormattedHours(),
        ),
        charts.Series<UnitWorkingTime, String>(
          id: 'Idling',
          domainFn: (UnitWorkingTime timer, _) => "",
          measureFn: (UnitWorkingTime timer, _) => timer.idlingInSeconds,
          data: [data],
          colorFn: (_, __) =>
              Theme.of(context).colorScheme.onSurface.toChartColor(),
          labelAccessorFn: (UnitWorkingTime timer, _) =>
              timer.idlingInFormattedHours(),
        )
      ];
}
