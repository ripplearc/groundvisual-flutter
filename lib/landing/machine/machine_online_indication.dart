import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MachineOnlineIndication extends StatelessWidget {
  final Size rightBottomOffset;

  const MachineOnlineIndication({Key key, this.rightBottomOffset}) : super(key: key);
  @override
  Widget build(BuildContext context) => Positioned(
      right: rightBottomOffset.width,
      bottom: rightBottomOffset.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 20,
            color: Theme.of(context).colorScheme.background,
          ),
          Icon(
            Icons.circle,
            size: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ));
}
