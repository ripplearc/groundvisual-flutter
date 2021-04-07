import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/animation/daily_digest_decoration_planner.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_collage_cover.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_play_button.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_playing.dart';

/// Display the digest of daily activity with animation.
class DailyDigestSlideShow extends StatelessWidget {
  final double aspectRatio;

  const DailyDigestSlideShow({Key? key, required this.aspectRatio}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DailyDigestCollageCover(),
                  DailyDigestSlidePlaying(
                      getIt<DailyDigestDecorationPlanner>()),
                  DailyDigestPlayButton()
                ],
              ),
            ),
          ]));
}
