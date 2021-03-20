import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/model/digest_image_model.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/animation/daily_digest_decoration_planner.dart';

import 'animation/daily_digest_animation_controller.dart';
import 'animation/daily_digest_decoration_animation.dart';
import 'animation/daily_digest_slide_animation.dart';

/// Animate sliding in the next digest image, and pause when touching anywhere on the image.
class DailyDigestSlidePlaying extends StatelessWidget {
  final double padding = 1;
  final DailyDigestDecorationPlanner dailyDigestDecorationPlanner;

  DailyDigestSlidePlaying(this.dailyDigestDecorationPlanner);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(
          buildWhen: (prev, curr) => curr is PlayDigestShowImage,
          builder: (context, state) {
            if (state is PlayDigestShowImage) {
              return GestureDetector(
                  onTap: () {
                    BlocProvider.of<PlayDigestBloc>(context)
                        .add(PlayDigestPause(state.siteName, state.date));
                  },
                  child: _genAnimatedSlide(state.images));
            } else {
              return Container();
            }
          });

  Padding _genAnimatedSlide(DigestImageModel images) => Padding(
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(builder: (context, constraints) {
        final Size size = constraints.biggest;
        final tweens = dailyDigestDecorationPlanner.getDecorationTweens(size);
        return Stack(
          children: [
                _genCurrentImage(images),
                _genNextImageWithAnimation(images, size)
              ] +
              tweens
                  .asMap()
                  .entries
                  .map(
                    (entry) => _genDecorationWithAnimation(
                        images, size, entry.value, entry.key.toString()),
                  )
                  .toList(),
        );
      }));

  Widget _genDecorationWithAnimation(DigestImageModel images,
          Size benchmarkSize, Tween tween, String key) =>
      images.nextImage != null
          ? DailyDigestAnimationController(
              key: Key(images.nextImage + key),
              animatedWidgetBuilder:
                  _getDecorationAnimationBuilder(benchmarkSize, tween))
          : Container();

  Widget _genNextImageWithAnimation(DigestImageModel images, Size size) =>
      images.nextImage != null
          ? DailyDigestAnimationController(
              key: Key(images.nextImage),
              animatedWidgetBuilder:
                  _getSlideAnimationBuilder(images.nextImage, size))
          : Container();

  Widget _genCurrentImage(DigestImageModel images) =>
      images.currentImage != null
          ? _genStaticImage(images.currentImage)
          : Container();

  Function _getSlideAnimationBuilder(String image, Size imageSize) =>
      (AnimationController controller) => DailyDigestSlideAnimation(
          controller: controller, image: image, imageSize: imageSize);

  Function _getDecorationAnimationBuilder(Size size, Tween tween) =>
      (AnimationController controller) => DailyDigestDecorationAnimation(
          controller: controller, imageSize: size, tween: tween);

  Image _genStaticImage(String images) => Image.asset(
        images,
        fit: BoxFit.cover,
      );
}
