import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/daily_digest_cover_collage.dart';
import 'package:groundvisual_flutter/landing/digest/stream_annimation_playground.dart';

class DailyDigestPhotoShow extends StatelessWidget {
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
              child: BlocProvider(
                create: (_) => getIt<PlayDigestBloc>(),
                child: Stack(
                  children: [DailyDigestCoverCollage(), StreamAnimationSlide()],
                ),
              ),
            )
          ]));
}
