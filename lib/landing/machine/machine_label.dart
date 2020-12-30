import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MachineLabel extends StatelessWidget {
  final String label;
  final Size size;
  final Size topLeftOffset;

  const MachineLabel({Key key, this.label, this.topLeftOffset, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        overflow: Overflow.visible,
        children: [
          _genOffset(context),
          _genForeground(context),
        ],
      );

  Positioned _genOffset(BuildContext context) => Positioned(
      top: topLeftOffset.height,
      left: topLeftOffset.width,
      child: ClipOval(
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primary,
        ),
      ));

  ClipOval _genForeground(BuildContext context) => ClipOval(
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
}
