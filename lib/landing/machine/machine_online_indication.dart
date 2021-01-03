import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Online indication that the machine can send and receive messages.
class MachineOnlineIndication extends StatelessWidget {
  final Size rightBottomOffset;

  const MachineOnlineIndication({Key key, this.rightBottomOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
      right: rightBottomOffset.width,
      bottom: rightBottomOffset.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _genShadow(context),
          _genOnlineIndicator(context),
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
