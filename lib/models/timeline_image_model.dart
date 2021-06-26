import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/models/image_downloading_model.dart';

/// Working status of the machine in the duration
enum MachineStatus { working, idling, stationary }

extension ParseToString on MachineStatus {
  String value() => this.toString().split('.').last;
}

enum MachineActivity { trenching, dig, install_pipe, level, hoist, load }

extension ParseActivityToString on MachineActivity {
  String value() => this.toString().split('.').last;
}

/// Timestamp and working status of the image in that duration
class TimelineImageModel {
  final String imageName;
  final MachineStatus status;
  final Set<MachineActivity> activities;
  final ImageDownloadingModel downloadingModel;

  TimelineImageModel(this.imageName,
      {required this.status,
      required this.activities,
      required this.downloadingModel});

  String get timeString =>
      [downloadingModel.timeRange.start, downloadingModel.timeRange.end]
          .map((time) => time.toHourMinuteString())
          .reduce((value, element) => value + " ~ " + element);

  Set<String> get activityLabels {
    if (<MachineStatus>[MachineStatus.stationary, MachineStatus.idling]
        .contains(status)) {
      return {status.value()};
    } else {
      return activities.map((e) => e.value()).toSet();
    }
  }
}
