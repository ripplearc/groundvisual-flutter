import 'package:fl_chart/fl_chart.dart';

/// data model to display daily working chart
class WorkingTimeChartData {
  List<BarChartGroupData> bars;
  List<List<BarTooltipItem>> tooltips;
  double leftTitleInterval;
  double space;
  List<String> bottomTitles;

  WorkingTimeChartData(
    this.bars,
    this.tooltips,
    this.leftTitleInterval,
    this.space,
    this.bottomTitles,
  );
}
