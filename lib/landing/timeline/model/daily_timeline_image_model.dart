/// Working status of the machine in the duration
enum MachineStatus { working, idling, stationary }

extension ParseToString on MachineStatus {
  String value() => this.toString().split('.').last;
}

/// Timestamp and working status of the image in that duration
class DailyTimelineImageModel {
  final String imageName;
  final DateTime startTime;
  final DateTime endTime;
  final MachineStatus status;

  DailyTimelineImageModel(
      this.imageName, this.startTime, this.endTime, this.status);
}
