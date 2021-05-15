import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';

part 'timeline_gallery_event.dart';

part 'timeline_gallery_state.dart';

/// Convert an array of [TimelineImageModel] to [GalleryItem], to be displayed
/// in the gallery.
@injectable
class TimelineGalleryBloc
    extends Bloc<TimelineGalleryEvent, TimelineGalleryState> {
  TimelineGalleryBloc(@factoryParam List<TimelineImageModel>? images)
      : super(TimelineGalleryLoaded([])) {
    add(LoadingImagesToGallery(images ?? []));
  }

  @override
  Stream<TimelineGalleryState> mapEventToState(
    TimelineGalleryEvent event,
  ) async* {
    if (event is LoadingImagesToGallery) {
      yield TimelineGalleryLoaded(_getGalleryItems(event.images));
    }
  }

  List<GalleryItem> _getGalleryItems(List<TimelineImageModel> images) => images
      .mapWithIndex((index, value) => GalleryItem(
          tag: value.timeString,
          statusLabel: [MachineStatus.idling, MachineStatus.stationary]
                  .contains(value.status)
              ? " [ ${value.status.value().toUpperCase()} ] "
              : "",
          resource: value.imageName,
          isSvg: value.imageName.contains(".svg")))
      .toList();
}
