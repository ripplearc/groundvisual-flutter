import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/models/image_downloading_model.dart';

/// Working status of the machine in the duration
enum MachineStatus { working, idling, stationary }

extension ParseToString on MachineStatus {
  String value() => this.toString().split('.').last;
}

/// Timestamp and working status of the image in that duration
class TimelineImageModel {
  final String imageName;
  final MachineStatus status;
  final ImageDownloadingModel downloadingModel;

  TimelineImageModel(this.imageName,
      {required this.status, required this.downloadingModel});

  String get timeString =>
      [downloadingModel.timeRange.start, downloadingModel.timeRange.end]
          .map((time) => time.toHourMinuteString())
          .reduce((value, element) => value + " ~ " + element);
}
