import 'package:fl_chart/fl_chart.dart';

/// data model to display daily working chart
class WorkingTimeDailyChartData {
  List<BarChartGroupData> bars;
  List<List<BarTooltipItem>> tooltips;
  int leftTitleInterval;
  List<String> bottomTitles;

  WorkingTimeDailyChartData(
      this.bars, this.tooltips, this.leftTitleInterval, this.bottomTitles);
}