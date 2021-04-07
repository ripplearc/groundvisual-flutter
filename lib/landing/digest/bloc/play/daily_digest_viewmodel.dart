import 'dart:async';
import 'dart:math';

import 'package:groundvisual_flutter/landing/digest/model/digest_image_model.dart';
import 'package:injectable/injectable.dart';
import 'package:tuple/tuple.dart';
import 'package:dart_date/dart_date.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// Viewmodel for retrieving the cover and digest images. It is stateful and
/// increments the cursor after an image retrieval.
@injectable
class DailyDigestViewModel {
  static const int _NumberOfImages = 5;
  final _Cursor _cursor = _Cursor(_NumberOfImages);
  final _random = Random();

  final _imageListOfSiteAtDate =
      Map<Tuple2<String, DateTime>, List<Tuple2<String, DateTime>>>();

  Future<List<String>> coverImages(String siteName, DateTime date) =>
      Future.value(List.generate(
          5, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<Tuple2<String, DateTime>>> get _digestImages =>
      Future.value(List.generate(
          _NumberOfImages,
          (index) => Tuple2(
              'images/digest/summary_${index + 1}.jpg',
              Date.startOfToday
                  .addHours(6 + index * 2)
                  .addMinutes(_random.nextInt(4) * 15))));

  Future<void> preloadImages(String siteName, DateTime date) async {
    await _digestImages.then((value) => _imageListOfSiteAtDate.putIfAbsent(
        Tuple2(siteName, date), () => value));
    return;
  }

  Future<DigestImageModel> fetchNextImage(
      String siteName, DateTime date) async {
    final images = _imageListOfSiteAtDate[Tuple2(siteName, date)];
    DigestImageModel model = _cursor.let((it) {
      if (images == null) {
        return DigestImageModel(null, null, date.startOfDay);
      } else if (_cursor.atBeginning) {
        final element = images.elementAt(_cursor.next);
        return DigestImageModel(null, element.item1, element.item2);
      } else {
        return _getCurrentAndNextImages(images);
      }
    });
    _cursor.increment();
    return model;
  }

  bool shouldRewind() {
    if (_cursor.atEnd) {
      _cursor._reset();
      return true;
    }
    return false;
  }

  DigestImageModel _getCurrentAndNextImages(
          List<Tuple2<String, DateTime>> images) =>
      DigestImageModel(
        images.elementAt(_cursor.position).item1,
        images.elementAt(_cursor.next).item1,
        images.elementAt(_cursor.next).item2,
      );
}

/// Maintains the position of the current image position and reset after reaching the end.
class _Cursor {
  final int numberOfImages;
  int _currentPosition = -1;

  _Cursor(this.numberOfImages);

  increment() => _currentPosition++;

  _reset() {
    _currentPosition = -1;
  }

  bool get atBeginning => _currentPosition == -1;

  bool get atEnd => position == next;

  int get position => _currentPosition;

  int get next => min(_currentPosition + 1, numberOfImages - 1);
}
