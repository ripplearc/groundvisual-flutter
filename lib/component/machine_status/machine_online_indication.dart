import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Online indication that the machine can send and receive messages.
class MachineOnlineIndication extends StatelessWidget {
  final Size? rightBottomOffset;
  final bool? shimming;

  const MachineOnlineIndication(
      {Key? key, this.rightBottomOffset, this.shimming})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
      right: rightBottomOffset?.width ?? 0,
      bottom: rightBottomOffset?.height ?? 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _genShadow(context),
          shimming ?? false
              ? Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.onSurface,
                  child: _genOnlineIndicator(context))
              : _genOnlineIndicator(context)
        ],
      ));

  Icon _genOnlineIndicator(BuildContext context) => Icon(
        Icons.circle,
        size: 14,
        color: Theme.of(context).highlightColor,
      );

  Icon _genShadow(BuildContext context) => Icon(
        Icons.circle,
        size: 20,
        color: Theme.of(context).colorScheme.background,
      );
}
