import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:tuple/tuple.dart';
import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// Viewmodel for retrieving the cover and digest images. It is stateful and
/// increments the cursor after an image retrieval.
@injectable
class DailyDigestViewModel {
  final int _numberOfImages = 5;
  _Cursor _cursor;
  final random = Random();

  final _imageListOfSiteAtDate =
      Map<Tuple2<String, DateTime>, List<Tuple2<String, DateTime>>>();

  DailyDigestViewModel() {
    _cursor = _Cursor(_numberOfImages);
  }

  Future<List<String>> coverImages(String siteName, DateTime date) =>
      Future.value(List.generate(
          5, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<Tuple2<String, DateTime>>> get digestImages =>
      Future.value(List.generate(
          _numberOfImages,
          (index) => Tuple2(
              'images/digest/summary_${index + 1}.jpg',
              Date.startOfToday
                  .addHours(6 + index * 2)
                  .addMinutes(random.nextInt(4)*15))));

  Future<void> preloadImages(String siteName, DateTime date) async {
    _imageListOfSiteAtDate[Tuple2(siteName, date)] = await digestImages;
    return;
  }

  Future<DigestImageModel> incrementDigestImageCursor(
      String siteName, DateTime date) async {
    final images = _imageListOfSiteAtDate[Tuple2(siteName, date)];
    DigestImageModel model = _cursor.let((it) {
      if (images == null || _cursor.atEnding()) {
        return DigestImageModel(null, null, date.startOfDay);
      } else if (_cursor.atBeginning()) {
        final element = images.elementAt(_cursor.position);
        return DigestImageModel(null, element.item1, element.item2);
      } else {
        return _getCurrentAndNextImages(images);
      }
    });
    _cursor.incrementOrReset();
    return model;
  }

  DigestImageModel _getCurrentAndNextImages(
          List<Tuple2<String, DateTime>> images) =>
      DigestImageModel(
        images.elementAt(_cursor.prev).item1,
        images.elementAt(_cursor.position).item1,
        images.elementAt(_cursor.position).item2,
      );
}

class DigestImageModel {
  final String currentImage;
  final String nextImage;
  final DateTime time;

  DigestImageModel(this.currentImage, this.nextImage, this.time);

  @override
  String toString() =>
      "CurrentImage: $currentImage; NextImage: $nextImage; Time: $time";
}

/// Maintains the position of the current image position and reset after reaching the end.
class _Cursor {
  final int numberOfImages;
  int _currentPosition;

  _Cursor(this.numberOfImages) {
    _currentPosition = 0;
  }

  incrementOrReset() {
    final newPosition = _currentPosition++;
    if (newPosition == numberOfImages) _reset();
  }

  _reset() {
    _currentPosition = 0;
  }

  bool atEnding() => _currentPosition >= numberOfImages;

  bool atBeginning() => _currentPosition <= 0;

  int get position => _currentPosition;

  int get prev => max(_currentPosition - 1, 0);
}
