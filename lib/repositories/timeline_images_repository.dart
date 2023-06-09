import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/models/image_downloading_model.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:groundvisual_flutter/models/zone.dart';
import 'package:injectable/injectable.dart';

/// Fetch a list of [TimelineImageModel] for a group of machines [muids]
/// in a period [timeRange] at [siteName].
abstract class TimelineImagesRepository {
  /// Search for the group of [TimelineImageModel] at the [siteName] during the
  /// [timeRange] for the group of machines [muids]. This is for searching timeline
  /// images without specifying customized zone.
  Future<List<TimelineImageModel>> getTimelineImagesAtSite(
      String siteName, List<String> muids, DateTimeRange timeRange);

  /// Search for the group of [TimelineImageModel] at the specified [zone] during the
  /// [timeRange] for the group of machines [muids]. This is for searching timeline
  /// images by specifying customized zone.
  Future<List<TimelineImageModel>> getTimelineImagesAtZone(
      ConstructionZone zone, List<String> muids, DateTimeRange timeRange);
}

@LazySingleton(as: TimelineImagesRepository)
class TimelineImagesRepositoryImpl extends TimelineImagesRepository {
  @override
  Future<List<TimelineImageModel>> getTimelineImagesAtSite(
          String siteName, List<String> muids, DateTimeRange timeRange) =>
      _getMockImages(timeRange);

  @override
  Future<List<TimelineImageModel>> getTimelineImagesAtZone(
          ConstructionZone zone, List<String> muids, DateTimeRange timeRange) =>
      _getMockImages(timeRange);

  Future<List<TimelineImageModel>> _getMockImages(DateTimeRange timeRange) {
    final baseUrl =
        'https://raw.githubusercontent.com/ripplearc/ripplearc.github.io/main/images/Flutter/groundvisual/images/thumbnails/';
    return Future.value(List.generate(
        50,
        (index) => TimelineImageModel(
            index == 4
                ? 'assets/icon/excavator.svg'
                // : 'images/thumbnails/${index + 1}.jpg',
                : baseUrl + '${index + 1}.jpg',
            downloadingModel: ImageDownloadingModel("00001A",
                timeRange: DateTimeRange(
                    start: timeRange.start.startOfDay
                        .add(Duration(minutes: index * 15)),
                    end: timeRange.start.startOfDay
                        .add(Duration(minutes: index * 15 + 15))),
                numberOfImages: 100),
            status: _getMachineStatus(index),
            activities: _getMachineActivities(index))));
  }

  MachineStatus _getMachineStatus(int index) {
    if (index == 3) {
      return MachineStatus.idling;
    } else if (index == 4) {
      return MachineStatus.stationary;
    } else {
      return MachineStatus.working;
    }
  }

  Set<MachineActivity> _getMachineActivities(int index) {
    if (<int>[3, 4].contains(index)) {
      return {};
    } else if (index % 5 == 0) {
      return {MachineActivity.install_pipe};
    } else if (index % 7 == 0) {
      return {MachineActivity.trenching, MachineActivity.load};
    } else if (index % 13 == 0) {
      return {
        MachineActivity.level,
        MachineActivity.load,
        MachineActivity.install_pipe
      };
    } else {
      return {MachineActivity.dig};
    }
  }
}
