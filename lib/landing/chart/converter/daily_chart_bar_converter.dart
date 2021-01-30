import 'package:injectable/injectable.dart';
import 'package:dart_date/dart_date.dart';
import 'package:tuple/tuple.dart';

/// Compute the datetime given the the selected groupId and rodId on a daily chart.
@injectable
class DailyChartBarConverter {
  int get groupsPerDay => 24;

  int get secondsPerGroup => 3600;

  int get rodsPerGroup => 4;

  int get secondsPerRod => 900;

  int get rodsPerDay => groupsPerDay * rodsPerGroup;

  DateTime convertToDateTime(DateTime startTime, int groupId, int rodId) =>
      startTime + Duration(seconds: groupId * 3600 + rodId * 900);

  Tuple2<int, int> convertToIndices(DateTime time) {
    final elapseInSeconds = time.differenceInSeconds(time.startOfDay);
    int groupId = elapseInSeconds ~/ secondsPerGroup;
    int rodId =
        (elapseInSeconds - (groupId * secondsPerGroup)) ~/ secondsPerRod;
    return Tuple2(groupId, rodId);
  }
}
