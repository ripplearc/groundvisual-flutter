import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class DailyDigestViewModel {
  Future<List<String>> getCoverImages() => Future.value(
      List.generate(5, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<String>> getDigestImages() => Future.value(
      List.generate(10, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Stream<List<String>> getDigestPrevAndCurrentImagesWithTimeInterval(
          int intervalInSeconds) =>
      _digestPrevAndCurrentImages
          .zipWith(
              Stream.periodic(Duration(seconds: intervalInSeconds))
                  .startWith(null),
              (images, __) => images)
          .concatWith([
        Stream.value(List<String>.empty())
            .delay(Duration(seconds: intervalInSeconds))
      ]);

  Stream<List<String>> get _digestPrevAndCurrentImages => getDigestImages()
      .asStream()
      .flatMap((images) => Stream.fromIterable(images))
      .scan<List<String>>(
          (accumulated, value, index) =>
              (accumulated..insert(0, value)).take(2).toList(),
          <String>[]).map((images) => List<String>.from(images));
}
