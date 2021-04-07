import 'package:fl_chart/fl_chart.dart';

/// data model to display daily working chart
class WorkingTimeChartData {
  List<BarChartGroupData> bars;
  List<List<String>> tooltips;
  double leftTitleInterval;
  List<String> bottomTitles;

  WorkingTimeChartData({
    this.bars = const [],
    this.tooltips = const [],
    this.leftTitleInterval = 0,
    this.bottomTitles = const [],
  });

  WorkingTimeChartData copyWith(
          {List<BarChartGroupData>? barsParam,
          List<List<String>>? tooltipsParam,
          double? leftTitleIntervalParam,
          double? spaceParam,
          List<String>? bottomTitlesParam}) =>
      WorkingTimeChartData(
          bars: barsParam ?? bars,
          tooltips: tooltipsParam ?? tooltips,
          leftTitleInterval: leftTitleIntervalParam ?? leftTitleInterval,
          bottomTitles: bottomTitlesParam ?? bottomTitles);
}
