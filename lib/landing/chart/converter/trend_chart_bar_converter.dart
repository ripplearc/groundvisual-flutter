import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tuple/tuple.dart';

@injectable
class TrendChartBarConverter {
  int numOfGroup(TrendPeriod period) => _groupsAndDays(period).item1;

  int daysPerGroup(TrendPeriod period) => _groupsAndDays(period).item2;

  Tuple2<int, int> _groupsAndDays(TrendPeriod period) {
    switch (period) {
      case TrendPeriod.oneWeek:
        return Tuple2(7, 1);
      case TrendPeriod.twoWeeks:
        return Tuple2(5, 3);
      case TrendPeriod.oneMonth:
        return Tuple2(5, 6);
      case TrendPeriod.twoMonths:
        return Tuple2(5, 12);
    }
    return Tuple2(7, 1);
  }

  DateTime convertToDateTime(
          DateTimeRange range, TrendPeriod period, int groupId, int rodId) =>
      Date.min(
          range.start + Duration(days: groupId * numOfGroup(period) + rodId),
          range.end);
}
