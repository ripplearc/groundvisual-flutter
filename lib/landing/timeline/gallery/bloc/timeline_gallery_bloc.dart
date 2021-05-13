import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'timeline_gallery_event.dart';

part 'timeline_gallery_state.dart';

@injectable
class TimelineGalleryBloc
    extends Bloc<TimelineGalleryEvent, TimelineGalleryState> {
  TimelineGalleryBloc(@factoryParam this.galleryItems)
      : super(TimelineGalleryImages(galleryItems ));

  final List<GalleryItem>? galleryItems;

  @override
  Stream<TimelineGalleryState> mapEventToState(
    TimelineGalleryEvent event,
  ) async* {}
}
