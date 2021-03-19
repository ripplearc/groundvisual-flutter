import 'package:fl_chart/fl_chart.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:injectable/injectable.dart';

/// Set the width of the bar rod of the trend bar chart.
@injectable
class TrendBarRodMeasurement {
  final TrendChartBarConverter trendChartBarConverter;
  final double parentWidth;
  final TrendPeriod trendPeriod;

  double get _width {
    final numOfGroup = trendChartBarConverter.numOfGroup(trendPeriod);
    final daysPerGroup = trendChartBarConverter.daysPerGroup(trendPeriod);
    return parentWidth * 0.6 / (numOfGroup * daysPerGroup);
  }

  TrendBarRodMeasurement(this.trendChartBarConverter,
      @factoryParam this.parentWidth, @factoryParam this.trendPeriod);

  BarChartRodData setBarWidth(BarChartRodData rodData) =>
      rodData.copyWith(width: _width);

  BarChartGroupData setBarSpace(BarChartGroupData groupData) =>
      groupData.copyWith(barsSpace: _width * 0.5);

  double get groupSpace => _width * 0.5;
}

/// Set the width of the bar rod of the daily bar chart.
@injectable
class DailyBarRodMeasurement {
  final DailyChartBarConverter dailyChartBarConverter;
  final double parentWidth;
  double _width;

  DailyBarRodMeasurement(
      this.dailyChartBarConverter, @factoryParam this.parentWidth) {
    final numOfGroup = dailyChartBarConverter.groupsPerDay;
    final rodsPerGroup = dailyChartBarConverter.rodsPerGroup;
    _width = parentWidth * 0.8 / (numOfGroup * rodsPerGroup);
  }

  BarChartRodData setBarWidth(BarChartRodData rodData) =>
      rodData.copyWith(width: _width);

  BarChartGroupData setBarSpace(BarChartGroupData groupData) =>
      groupData.copyWith(barsSpace: _width * 0.7);

  double get groupSpace => _width * 0.7;
}
