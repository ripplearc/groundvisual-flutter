import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:groundvisual_flutter/extensions/stream_logger.dart';

class StreamAnimationSlide extends StatelessWidget {
  final Random random = Random();
  final double padding;

  StreamAnimationSlide({Key key, this.padding = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 4))
          .scan((accumulated, value, index) => accumulated + 1, 0)
          .take(5)
          .map((index) => 'images/digest/summary_$index.jpg')
          .scan<List<String>>(
              (acc, value, index) => (acc..insert(0, value)).take(2).toList(),
              <String>[]).log('🤘'),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
          snapshot.hasData ? _genAnimatedSlide(snapshot.data) : Container());

  Padding _genAnimatedSlide(List<String> images) => Padding(
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(builder: (context, constraints) {
        final Size imageSize = constraints.biggest;
        final beginRect = _getRandomBeginRect(imageSize);
        return Stack(
          children: [
            images.length > 1 ? _genStaticImage(images.last) : Container(),
            _genAnimatedImage(images.first ?? '', beginRect, imageSize)
          ],
        );
      }));

  Image _genStaticImage(String images) => Image.asset(
        images,
        fit: BoxFit.cover,
      );

  StreamAnimationSlideSample _genAnimatedImage(
          String image, Rect beginRect, Size imageSize) =>
      StreamAnimationSlideSample(
        key: Key(image),
        image: image,
        animationTime: 3,
        beginRect: beginRect,
        imageSize: imageSize,
      );

  Rect _getRandomBeginRect(Size imageSize) => [
        Rect.fromLTWH(0, -imageSize.height, imageSize.width, imageSize.height),
        Rect.fromLTWH(0, imageSize.height, imageSize.width, imageSize.height),
        Rect.fromLTWH(imageSize.width, 0, imageSize.width, imageSize.height),
        Rect.fromLTWH(-imageSize.width, 0, imageSize.width, imageSize.height),
      ].elementAt(random.nextInt(4));
}

/// This is the stateful widget that the main application instantiates.
class StreamAnimationSlideSample extends StatefulWidget {
  final String image;
  final int animationTime;
  final Rect beginRect;
  final Size imageSize;

  StreamAnimationSlideSample(
      {Key key, this.image, this.animationTime, this.beginRect, this.imageSize})
      : super(key: key);

  @override
  _StreamAnimationSlideSampleState createState() =>
      _StreamAnimationSlideSampleState(
          image, animationTime, beginRect, imageSize);
}

/// This is the private State class that goes with MyStatefulWidget.
class _StreamAnimationSlideSampleState extends State<StreamAnimationSlideSample>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<RelativeRect> _relativeRect;
  final String image;
  final int animationTime;
  final Rect beginRect;
  final Size imageSize;

  _StreamAnimationSlideSampleState(
      this.image, this.animationTime, this.beginRect, this.imageSize);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: animationTime),
      vsync: this,
    )..forward();

    _relativeRect = RelativeRectTween(
      begin: RelativeRect.fromSize(beginRect, imageSize),
      end: RelativeRect.fromSize(
          Rect.fromLTWH(0, 0, imageSize.width, imageSize.height), imageSize),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => PositionedTransition(
        rect: _relativeRect,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      );
}
