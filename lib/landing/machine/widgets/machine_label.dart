import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Label showing machine name and online status.
class MachineLabel extends StatelessWidget {
  final String name;
  final Size labelSize;
  final Size? shadowTopLeftOffset;

  const MachineLabel({
    Key? key,
    required this.name,
    required this.labelSize,
    this.shadowTopLeftOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          _genShadow(context),
          _genForeground(context),
        ],
      );

  Positioned _genShadow(BuildContext context) => Positioned(
      top: shadowTopLeftOffset?.height ?? 0,
      left: shadowTopLeftOffset?.width ?? 0,
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
                    ?.apply(color: Theme.of(context).colorScheme.primary) ??
                TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      );
}
