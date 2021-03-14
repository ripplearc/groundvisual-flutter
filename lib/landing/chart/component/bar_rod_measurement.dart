import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/converter/trend_chart_bar_converter.dart';
import 'package:injectable/injectable.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Set the width of the bar rod of the trend bar chart.
@injectable
class TrendBarRodMeasurement {
  final TrendChartBarConverter trendChartBarConverter;
  final BuildContext context;
  final TrendPeriod period;
  double _width;

  TrendBarRodMeasurement(this.trendChartBarConverter,
      @factoryParam this.context, @factoryParam this.period) {
    final numOfGroup = trendChartBarConverter.numOfGroup(period);
    final daysPerGroup = trendChartBarConverter.daysPerGroup(period);
    _width = _totalWidthOfBarRods(context) / (numOfGroup * daysPerGroup);
  }

  double _totalWidthOfBarRods(BuildContext context) =>
      getValueForScreenType<double>(
        context: context,
        mobile: 180,
        tablet: 260,
        desktop: 350,
      );

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
  final BuildContext context;
  double _width;

  DailyBarRodMeasurement(
      this.dailyChartBarConverter, @factoryParam this.context) {
    final numOfGroup = dailyChartBarConverter.groupsPerDay;
    final rodsPerGroup = dailyChartBarConverter.rodsPerGroup;
    _width = _totalWidthOfBarRods(context) / (numOfGroup * rodsPerGroup);
  }

  double _totalWidthOfBarRods(BuildContext context) =>
      getValueForScreenType<double>(
        context: context,
        mobile: 250,
        tablet: 350,
        desktop: 500,
      );

  BarChartRodData setBarWidth(BarChartRodData rodData) =>
      rodData.copyWith(width: _width);

  BarChartGroupData setBarSpace(BarChartGroupData groupData) =>
      groupData.copyWith(barsSpace: _width * 0.7);

  double get groupSpace => _width * 0.7;
}
