import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/play_digest_bloc.dart';

class DailyDigestPlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PlayDigestBloc, PlayDigestState>(builder: (context, state) {
        if (state is PlayDigestPausePlaying) {
          return _genPlayButton(context);
        } else if (state is PlayDigestBuffering) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          );
        } else {
          return Container();
        }
      });

  Container _genPlayButton(BuildContext context) => Container(
      width: 80,
      height: 80,
      child: IconButton(
          onPressed: () =>
              BlocProvider.of<PlayDigestBloc>(context).add(PlayDigestResume()),
          color: Colors.green,
          icon: Icon(
            Icons.play_arrow_sharp,
            size: 65,
            color: Theme.of(context).colorScheme.primary,
          )));
}
