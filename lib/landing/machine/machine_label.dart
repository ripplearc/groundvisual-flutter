import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Label showing machine name and online status.
class MachineLabel extends StatelessWidget {
  final String name;
  final Size labelSize;
  final Size shadowTopLeftOffset;

  const MachineLabel({Key key, this.name, this.shadowTopLeftOffset, this.labelSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        overflow: Overflow.visible,
        children: [
          _genShadow(context),
          _genForeground(context),
        ],
      );

  Positioned _genShadow(BuildContext context) => Positioned(
      top: shadowTopLeftOffset.height,
      left: shadowTopLeftOffset.width,
      child: ClipOval(
        child: Container(
          height: labelSize.height,
          width: labelSize.width,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primary,
        ),
      ));

  ClipOval _genForeground(BuildContext context) => ClipOval(
        child: Container(
          height: labelSize.height,
          width: labelSize.width,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
}