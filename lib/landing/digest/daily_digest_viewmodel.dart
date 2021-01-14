import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:groundvisual_flutter/extensions/stream_logger.dart';

@injectable
class DailyDigestViewModel {
  Future<List<String>> getCoverImages() => Future.value(
      List.generate(5, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Future<List<String>> getDigestImages() => Future.value(
      List.generate(10, (index) => 'images/digest/summary_${index + 1}.jpg'));

  Stream<List<String>> getDigestPrevAndCurrentImages() => getDigestImages()
      .asStream()
      .flatMap((images) => Stream.fromIterable(images))
      .scan<List<String>>(
          (accumulated, value, index) =>
              (accumulated..insert(0, value)).take(2).toList(),
          <String>[])
      .asyncExpand((images) =>
          Stream.value(List<String>.from(images)).delay(Duration(seconds: 4)))
      .concatWith(
          [Stream.value(List<String>.empty()).delay(Duration(seconds: 4))]);
}
