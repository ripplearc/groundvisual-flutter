import 'package:fl_chart/fl_chart.dart';

/// data model to display daily working chart
class WorkingTimeChartData {
  List<BarChartGroupData> bars;
  List<List<String>> tooltips;
  double leftTitleInterval;
  List<String> bottomTitles;

  WorkingTimeChartData(
    this.bars,
    this.tooltips,
    this.leftTitleInterval,
    this.bottomTitles,
  );

  WorkingTimeChartData copyWith(
          {List<BarChartGroupData> barsParam,
          List<List<String>> tooltipsParam,
          double leftTitleIntervalParam,
          double spaceParam,
          List<String> bottomTitlesParam}) =>
      WorkingTimeChartData(
          barsParam ?? bars,
          tooltipsParam ?? tooltips,
          leftTitleIntervalParam ?? leftTitleInterval,
          bottomTitlesParam ?? bottomTitles);
}
