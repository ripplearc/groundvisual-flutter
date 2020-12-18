import 'package:injectable/injectable.dart';

@injectable
class DailyChartBarConverter {
  int get groupsPerDay => 24;

  int get rodsPerGroup => 4;

  int get rodsPerDay => groupsPerDay * rodsPerGroup;

  DateTime convertToDateTime(DateTime startTime, int groupId, int rodId) {
    return startTime.add(Duration(seconds: groupId * 3600 + rodId * 900));
  }
}
