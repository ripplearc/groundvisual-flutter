import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play/play_digest_bloc.dart';

/// Display a collage of images before playing digest.
class DailyDigestCollageCover extends StatelessWidget {
  final double padding;

  DailyDigestCollageCover({Key? key, this.padding = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(
          buildWhen: (prev, curr) => curr is PlayDigestPausePlaying,
          builder: (context, state) =>
              state is PlayDigestPausePlaying && state.coverImages.length >= 4
                  ? Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: _genCollageLayout(state.coverImages),
                    )
                  : Container());

  StatelessWidget _genCollageLayout(List<String> coverImages) =>
      {
        4: _DailyDigestCollageCoverWithFourPhotos(
            padding: padding, coverImages: coverImages),
        5: _DailyDigestCollageCoverWithFivePhotos(
            padding: padding, coverImages: coverImages)
      }[coverImages.length] ??
      Container();
}

class _DailyDigestCollageCoverWithFourPhotos extends StatelessWidget {
  final List<String> coverImages;
  final double padding;

  _DailyDigestCollageCoverWithFourPhotos(
      {Key? key, required this.padding, required this.coverImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(padding),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child:
                _layoutImagesHorizontally(coverImages.getRange(0, 3).toList()),
            flex: 8,
          ),
          _paddedImage(coverImages.elementAt(3), 2),
        ]),
      );
}

class _DailyDigestCollageCoverWithFivePhotos extends StatelessWidget {
  final double padding;
  final List<String> coverImages;

  const _DailyDigestCollageCoverWithFivePhotos(
      {Key? key, required this.padding, required this.coverImages})
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
                    child: _layoutImagesHorizontally(
                        coverImages.getRange(0, 2).toList()),
                  ),
                  _paddedImage(coverImages.elementAt(2), 2),
                ],
              )),
          Expanded(
              flex: 1,
              child: _layoutImagesVertically(coverImages
                  .getRange(coverImages.length - 2, coverImages.length)
                  .toList())),
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
        padding: EdgeInsets.all(0.2),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        )));
