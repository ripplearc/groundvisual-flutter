import 'package:fl_chart/fl_chart.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:injectable/injectable.dart';

/// Set the width of the bar rod of the trend bar chart.
@injectable
class TrendBarRodMeasurement {
  final TrendChartBarConverter trendChartBarConverter;
  final double totalWidth;
  final TrendPeriod period;
  double _width;

  TrendBarRodMeasurement(this.trendChartBarConverter,
      @factoryParam this.totalWidth, @factoryParam this.period) {
    final numOfGroup = trendChartBarConverter.numOfGroup(period);
    final daysPerGroup = trendChartBarConverter.daysPerGroup(period);
    _width = totalWidth / (numOfGroup * daysPerGroup);
  }

  BarChartRodData setBarWidth(BarChartRodData rodData) =>
      rodData.copyWith(width: _width);
}

/// Set the width of the bar rod of the daily bar chart.
@injectable
class DailyBarRodMeasurement {
  final DailyChartBarConverter dailyChartBarConverter;
  final double totalWidth;
  double _width;

  DailyBarRodMeasurement(
      this.dailyChartBarConverter, @factoryParam this.totalWidth) {
    final numOfGroup = dailyChartBarConverter.groupsPerDay;
    final rodsPerGroup = dailyChartBarConverter.rodsPerGroup;
    _width = totalWidth / (numOfGroup * rodsPerGroup);
  }

  BarChartRodData setBarWidth(BarChartRodData rodData) =>
      rodData.copyWith(width: _width);
}
