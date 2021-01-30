import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_viewmodel.dart';

/// Animate sliding in the next digest image, and pause when touching anywhere on the image.
class DailyDigestSlidePlaying extends StatelessWidget {
  final Random random = Random();
  final double padding;

  DailyDigestSlidePlaying({Key key, this.padding = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(buildWhen: (prev, curr) {
        return curr is PlayDigestShowImage;
      }, builder: (context, state) {
        if (state is PlayDigestShowImage) {
          return GestureDetector(
              onTap: () {
                BlocProvider.of<PlayDigestBloc>(context)
                    .add(PlayDigestPause(context, state.siteName, state.date));
              },
              child: _genAnimatedSlide(state.images));
        } else {
          return Container();
        }
      });

  Padding _genAnimatedSlide(DigestImageModel images) => Padding(
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(builder: (context, constraints) {
        final Size imageSize = constraints.biggest;
        final beginRect = _getRandomBeginRect(imageSize);
        return Stack(
          children: [
            images.currentImage != null ? _genStaticImage(images.currentImage) : Container(),
            images.nextImage != null
                ? _genAnimatedImage(images.nextImage ?? '', beginRect, imageSize)
                : Container()
          ],
        );
      }));

  Image _genStaticImage(String images) => Image.asset(
        images,
        fit: BoxFit.cover,
      );

  _DailyDigestSlideAnimation _genAnimatedImage(
          String image, Rect beginRect, Size imageSize) =>
      _DailyDigestSlideAnimation(
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
class _DailyDigestSlideAnimation extends StatefulWidget {
  final String image;
  final int animationTime;
  final Rect beginRect;
  final Size imageSize;

  _DailyDigestSlideAnimation(
      {Key key, this.image, this.animationTime, this.beginRect, this.imageSize})
      : super(key: key);

  @override
  _DailyDigestSlideAnimationState createState() =>
      _DailyDigestSlideAnimationState(
          image, animationTime, beginRect, imageSize);
}

/// This is the private State class that goes with MyStatefulWidget.
class _DailyDigestSlideAnimationState extends State<_DailyDigestSlideAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<RelativeRect> _relativeRect;
  final String image;
  final int animationTime;
  final Rect beginRect;
  final Size imageSize;

  _DailyDigestSlideAnimationState(
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
