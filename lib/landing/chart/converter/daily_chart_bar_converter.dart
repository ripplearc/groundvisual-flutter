import 'package:injectable/injectable.dart';
import 'package:dart_date/dart_date.dart';

/// Compute the datetime given the the selected groupId and rodId on a daily chart.
@injectable
class DailyChartBarConverter {
  int get groupsPerDay => 24;

  int get rodsPerGroup => 4;

  int get rodsPerDay => groupsPerDay * rodsPerGroup;

  DateTime convertToDateTime(DateTime startTime, int groupId, int rodId) =>
      startTime + Duration(seconds: groupId * 3600 + rodId * 900);
}
