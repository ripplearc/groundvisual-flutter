import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MachineOfflineIndication extends StatelessWidget {
  final Size offset;

  const MachineOfflineIndication({Key key, this.offset}) : super(key: key);


  @override
  Widget build(BuildContext context) => Positioned(
      right: offset.width,
      bottom: offset.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 32,
            height: 21,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(7))),
          ),
          Container(
            width: 27,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Text(
              '20h',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .overline
                  .apply(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ));
}
