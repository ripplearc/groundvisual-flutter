import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';

class DailyDigestCoverCollage extends StatelessWidget {
  final double padding;

  DailyDigestCoverCollage({Key key, this.padding = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _genRanCollageLayout(),
            _genPlayButton(context),
          ],
        ),
      );

  StatelessWidget _genRanCollageLayout() => [
        _DailyDigestCoverCollageLayoutOne(padding: padding),
        _DailyDigestCoverCollageLayoutTwo(padding: padding)
      ].elementAt(Random().nextInt(2));

  Container _genPlayButton(BuildContext context) => Container(
      width: 80,
      height: 80,
      child: IconButton(
          onPressed: () {
            BlocProvider.of<PlayDigestBloc>(context).add(PlayDigestResume());
          },
          color: Colors.green,
          icon: Icon(
            Icons.play_arrow_sharp,
            size: 65,
            color: Theme.of(context).colorScheme.primary,
          )));
}

class _DailyDigestCoverCollageLayoutOne extends StatelessWidget {
  final double padding;

  _DailyDigestCoverCollageLayoutOne({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(padding),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              flex: 8,
              child: _layoutImagesHorizontally(
                [
                  'images/digest/summary_1.jpg',
                  'images/digest/summary_2.jpg',
                  'images/digest/summary_3.jpg'
                ],
              )),
          _paddedImage('images/digest/summary_4.jpg', 2),
        ]),
      );
}

class _DailyDigestCoverCollageLayoutTwo extends StatelessWidget {
  final double padding;

  const _DailyDigestCoverCollageLayoutTwo({Key key, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(padding),
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 8,
                    child: _layoutImagesHorizontally([
                      'images/digest/summary_1.jpg',
                      'images/digest/summary_2.jpg'
                    ]),
                  ),
                  _paddedImage('images/digest/summary_3.jpg', 2),
                ],
              )),
          Expanded(
              flex: 1,
              child: _layoutImagesVertically(
                ['images/digest/summary_4.jpg', 'images/digest/summary_5.jpg'],
              )),
        ]),
      );
}

Widget _layoutImagesHorizontally(List<String> images) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: images.map((image) => _paddedImage(image, 1)).toList());

Widget _layoutImagesVertically(List<String> images) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: images.map((image) => _paddedImage(image, 1)).toList());

Widget _paddedImage(String image, int flex) => Expanded(
    flex: flex,
    child: Padding(
        padding: EdgeInsets.all(1),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        )));
