import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';

/// Viewmodel for retrieving the cover and digest images. It is stateful and
/// increments the cursor after an image retrieval.
@injectable
class DailyDigestViewModel {
  final int _numberOfImages = 3;
  _Cursor _cursor;

  DailyDigestViewModel() {
    _cursor = _Cursor(_numberOfImages);
  }

  Future<List<String>> get coverImages => Future.value(
      List.generate(5, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<String>> get digestImages => Future.value(List.generate(
      _numberOfImages, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<String>> incrementCurrentDigestImageCursor() async {
    final pair = await digestImages.then((images) {
      if (_cursor.atEnding()) {
        return <String>[];
      } else if (_cursor.atBeginning()) {
        return [images.elementAt(_cursor.position)];
      } else {
        return _getCurrentAndPrevImages(images);
      }
    });
    _cursor.incrementOrReset();
    return pair;
  }

  List<String> _getCurrentAndPrevImages(List<String> images) =>
      [images.elementAt(_cursor.position), images.elementAt(_cursor.prev)];
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
