import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_collage_cover.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_play_button.dart';
import 'package:groundvisual_flutter/landing/digest/widgets/daily_digest_slide_playing.dart';

/// Display the digest of daily activity with animation.
class DailyDigestSlideShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title:
                  Text('Digest', style: Theme.of(context).textTheme.headline5),
            ),
            AspectRatio(
              aspectRatio: 336 / 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DailyDigestCollageCover(),
                  DailyDigestSlidePlaying(),
                  DailyDigestPlayButton()
                ],
              ),
            ),
          ]));
}
