import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

/// RDS toggle button to toggle among a few options, and execute action upon selecting a new option
class ToggleButton extends StatelessWidget {
  final int initialIndex;
  final labels;
  final double widthPercent;
  final double height;

  final Function(int index) toggleAction;

  const ToggleButton(
      {Key? key,
      this.initialIndex = 0,
      required this.toggleAction,
      this.labels,
      required this.widthPercent,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FlutterToggleTab(
      width: widthPercent,
      borderRadius: 30,
      height: height,
      initialIndex: initialIndex,
      selectedBackgroundColors: [Theme.of(context).colorScheme.primary],
      unSelectedBackgroundColors: [Theme.of(context).colorScheme.surface],
      selectedTextStyle: Theme.of(context)
              .textTheme
              .caption
              ?.apply(color: Theme.of(context).colorScheme.background) ??
          TextStyle(color: Theme.of(context).colorScheme.background),
      unSelectedTextStyle: Theme.of(context)
              .textTheme
              .caption
              ?.apply(color: Theme.of(context).colorScheme.primary) ??
          TextStyle(color: Theme.of(context).colorScheme.primary),
      labels: labels,
      selectedLabelIndex: toggleAction);
}
