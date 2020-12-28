import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MachineBarChartSample extends StatelessWidget {
  MachineBarChartSample();

  @override
  Widget build(BuildContext context) {
    // return Card(
    //     elevation: 4,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    //     color: Theme.of(context).colorScheme.background,
    //     child: Padding(
    //         padding: const EdgeInsets.all(0.0),
    //         child: AspectRatio(
    //             aspectRatio: 4,
    //             child: getPlotBandRecurrenceChart(context))));
    return _getDefaultBarChart(context);
    // return _getDefaultBarChart2();
  }

  /// Returns the ccolumn chart with plot band recurrence.
  SfCartesianChart _getPlotBandRecurrenceChart(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: ''),
      plotAreaBorderWidth: 0,
      isTransposed: true,
      primaryXAxis: DateTimeAxis(
          interval: 5,
          dateFormat: DateFormat.y(),
          axisLine: AxisLine(width: 0),
          // majorGridLines: MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.years,
          edgeLabelPlacement: EdgeLabelPlacement.hide,
          minimum: DateTime(1990, 1, 1),
          maximum: DateTime(1990, 1, 1),
          labelStyle: const TextStyle(fontSize: 0)),

      /// API for X axis plot band.

      primaryYAxis: NumericAxis(
          minimum: 0,
          interval: 2000,
          maximum: 18000,

          /// API for Y axis plot band.

          majorGridLines: MajorGridLines(color: Colors.grey, width: 0),
          majorTickLines: MajorTickLines(size: 0),
          axisLine: AxisLine(width: 0),
          labelStyle: const TextStyle(fontSize: 0)),
      series: _getPlotBandRecurrenceSeries(context),
      tooltipBehavior:
          TooltipBehavior(enable: true, canShowMarker: false, header: ''),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, DateTime>> _getPlotBandRecurrenceSeries(
      BuildContext context) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      // ChartSampleData(x: DateTime(1980, 1, 1), y: 15400, yValue: 6400),
      // ChartSampleData(x: DateTime(1985, 1, 1), y: 15800, yValue: 3700),
      ChartSampleData(x: DateTime(1990, 1, 1), y: 14000, yValue: 7200),
      // ChartSampleData(x: DateTime(1995, 1, 1), y: 10500, yValue: 2300),
      // ChartSampleData(x: DateTime(2000, 1, 1), y: 13300, yValue: 4000),
      // ChartSampleData(x: DateTime(2005, 1, 1), y: 12800, yValue: 4800)
    ];
    return <ColumnSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        color: Theme.of(context).colorScheme.onSurface,
        spacing: 0.4,
        name: 'All sources',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        borderRadius: BorderRadius.circular(5),
        dataLabelSettings: DataLabelSettings(
            textStyle: Theme.of(context)
                .textTheme
                .button
                .apply(color: Theme.of(context).colorScheme.onBackground),
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto),
      ),
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        spacing: 0.4,
        color: Theme.of(context).colorScheme.primary,
        name: 'Autos & Light Trucks',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        borderRadius: BorderRadius.circular(5),
        dataLabelSettings: DataLabelSettings(
            textStyle: Theme.of(context)
                .textTheme
                .button
                .apply(color: Theme.of(context).colorScheme.onBackground),
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto),
      )
    ];
  }

  /// Returns the default cartesian bar chart.
  SfCartesianChart _getDefaultBarChart(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ''),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 0),
      ),
      primaryYAxis: NumericAxis(
        maximum: 8,
        majorGridLines: MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 0),
      ),
      series: _getDefaultBarSeries(context),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the barchart.
  List<BarSeries<ChartSampleData, String>> _getDefaultBarSeries(
      BuildContext context) {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'France',
        y: 1.2,
        secondSeriesYValue: 4.6,
      ),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: Theme.of(context).colorScheme.onSurface,
          spacing: 0.1,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          borderRadius: BorderRadius.circular(5),
          dataLabelSettings: DataLabelSettings(
              textStyle: Theme.of(context)
                  .textTheme
                  .button
                  .apply(color: Theme.of(context).colorScheme.onBackground),
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto),
          name: '2015'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          color: Theme.of(context).colorScheme.primary,
          spacing: 0.1,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          borderRadius: BorderRadius.circular(5),
          dataLabelSettings: DataLabelSettings(
              textStyle: Theme.of(context)
                  .textTheme
                  .button
                  .apply(color: Theme.of(context).colorScheme.onBackground),
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto),
          name: '2016'),
    ];
  }

 /////////////
///*********///
///
  /// Returns the default cartesian bar chart.
  SfCartesianChart _getDefaultBarChart2() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ''),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact()),
      series: _getDefaultBarSeries2(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the barchart.
  List<BarSeries<ChartSampleData, String>> _getDefaultBarSeries2() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'France',
          y: 84452000,
          secondSeriesYValue: 82682000,
          thirdSeriesYValue: 86861000),
      ChartSampleData(
          x: 'Spain',
          y: 68175000,
          secondSeriesYValue: 75315000,
          thirdSeriesYValue: 81786000),
      ChartSampleData(
          x: 'US',
          y: 77774000,
          secondSeriesYValue: 76407000,
          thirdSeriesYValue: 76941000),
      ChartSampleData(
          x: 'Italy',
          y: 50732000,
          secondSeriesYValue: 52372000,
          thirdSeriesYValue: 58253000),
      ChartSampleData(
          x: 'Mexico',
          y: 32093000,
          secondSeriesYValue: 35079000,
          thirdSeriesYValue: 39291000),
      ChartSampleData(
          x: 'UK',
          y: 34436000,
          secondSeriesYValue: 35814000,
          thirdSeriesYValue: 37651000),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '2015'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: '2016'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: '2017')
    ];
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color pointColor;

  /// Holds size of the datapoint
  final num size;

  /// Holds datalabel/text value mapper of the datapoint
  final String text;

  /// Holds open value of the datapoint
  final num open;

  /// Holds close value of the datapoint
  final num close;

  /// Holds low value of the datapoint
  final num low;

  /// Holds high value of the datapoint
  final num high;

  /// Holds open value of the datapoint
  final num volume;
}
