import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// Calculate the randomized tween for horizontal and vertical tween.
@injectable
class DailyDigestDecorationPlanner {
  final double thickness = 2;
  final double xDecorationAnchor = 80;
  final double yDecorationAnchor = 40;
  final random = Random();

  List<Tween> getDecorationTweens(Size benchmarkSize) {
    final Size decorationSize = _randomSize(benchmarkSize);
    final Offset decorationOffset = _randomOffset(benchmarkSize);
    return <Tween>[
      _getHorizontalDecorationTween(
          benchmarkSize, decorationOffset, decorationSize.width),
      _getVerticalDecorationTween(
          benchmarkSize, decorationOffset, decorationSize.height)
    ];
  }

  Tween _getHorizontalDecorationTween(
          Size benchmarkSize, Offset offset, double length) =>
      RelativeRectTween(
          begin: RelativeRect.fromSize(
              Rect.fromLTWH(-benchmarkSize.width, offset.dy, length, thickness),
              benchmarkSize),
          end: RelativeRect.fromSize(
              Rect.fromLTWH(_adjustStartX(length, benchmarkSize, offset),
                  offset.dy, length, thickness),
              benchmarkSize));

  Tween _getVerticalDecorationTween(
          Size benchmarkSize, Offset offset, length) =>
      RelativeRectTween(
          begin: RelativeRect.fromSize(
              Rect.fromLTWH(offset.dx, benchmarkSize.height, thickness, length),
              benchmarkSize),
          end: RelativeRect.fromSize(
              Rect.fromLTWH(
                  offset.dx,
                  _adjustStartY(length, benchmarkSize, offset),
                  thickness,
                  length),
              benchmarkSize));

  double _adjustStartX(double length, Size benchmarkSize, Offset offset) =>
      length < benchmarkSize.width && offset.dx * 2 > benchmarkSize.width
          ? offset.dx
          : 0;

  double _adjustStartY(length, Size benchmarkSize, Offset offset) =>
      length < benchmarkSize.height && offset.dy * 2 > benchmarkSize.height
          ? offset.dy
          : 0;

  Offset _randomOffset(Size size) => Offset(
      random.nextBool() ? xDecorationAnchor : size.width - xDecorationAnchor,
      random.nextBool() ? yDecorationAnchor : size.height - yDecorationAnchor);

  Size _randomSize(Size size) => random.nextInt(3).let((seed) {
        switch (seed) {
          case 0:
            return size;
          case 1:
            return Size(size.width, yDecorationAnchor);
          case 2:
            return Size(xDecorationAnchor, size.height);
          default:
            return Size.zero;
        }
      });
}
