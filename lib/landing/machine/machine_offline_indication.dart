import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Offline indication with warning message for how long the machine has been offline.
class MachineOfflineIndication extends StatelessWidget {
  final Size offset;
  final String warning;

  const MachineOfflineIndication({Key key, this.offset, this.warning})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
      right: offset.width,
      bottom: offset.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _genShadow(context),
          _genOfflineWarning(context),
        ],
      ));

  Container _genOfflineWarning(BuildContext context) => Container(
        width: 27,
        height: 15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Text(
          warning,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .overline
              .apply(color: Theme.of(context).colorScheme.error),
        ),
      );

  Container _genShadow(BuildContext context) => Container(
        width: 32,
        height: 21,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(7))),
      );
}
