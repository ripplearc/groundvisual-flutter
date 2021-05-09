import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/models/image_downloading_model.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:injectable/injectable.dart';

abstract class TimelineImagesRepository {
  Future<List<TimelineImageModel>> getTimelineImages(
      List<String> muid, DateTimeRange timeRange);
}

@LazySingleton(as: TimelineImagesRepository)
class TimelineImagesRepositoryImpl extends TimelineImagesRepository {
  @override
  Future<List<TimelineImageModel>> getTimelineImages(
          List<String> muid, DateTimeRange timeRange) =>
      Future.value(List.generate(
          50,
          (index) => TimelineImageModel(
              index == 4
                  ? 'assets/icon/excavator.svg'
                  : 'images/thumbnails/${index + 1}.jpg',
              downloadingModel: ImageDownloadingModel("00001A",
                  timeRange: DateTimeRange(
                      start:
                          Date.startOfToday.add(Duration(minutes: index * 15)),
                      end: Date.startOfToday
                          .add(Duration(minutes: index * 15 + 15))),
                  numberOfImages: 100),
              status: _getMachineStatus(index))));

  MachineStatus _getMachineStatus(int index) {
    if (index == 3) {
      return MachineStatus.idling;
    } else if (index == 4) {
      return MachineStatus.stationary;
    } else {
      return MachineStatus.working;
    }
  }
}
