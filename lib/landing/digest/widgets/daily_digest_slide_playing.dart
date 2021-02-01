import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/model/digest_image_model.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_animation.dart';

/// Animate sliding in the next digest image, and pause when touching anywhere on the image.
class DailyDigestSlidePlaying extends StatelessWidget {
  final double padding;

  DailyDigestSlidePlaying({Key key, this.padding = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(
          buildWhen: (prev, curr) => curr is PlayDigestShowImage,
          builder: (context, state) {
            if (state is PlayDigestShowImage) {
              return GestureDetector(
                  onTap: () {
                    BlocProvider.of<PlayDigestBloc>(context).add(
                        PlayDigestPause(context, state.siteName, state.date));
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
        return Stack(
          children: [
            images.currentImage != null
                ? _genStaticImage(images.currentImage)
                : Container(),
            // images.nextImage != null
            //     ? _genAnimatedImage(
            //         images.nextImage ?? '', beginRect, imageSize)
            //     : Container()
            images.nextImage != null
                ? DailyDigestSlideAnimation(
                    image: images.nextImage, imageSize: imageSize)
                : Container()
          ],
        );
      }));

  Image _genStaticImage(String images) => Image.asset(
        images,
        fit: BoxFit.cover,
      );
}
