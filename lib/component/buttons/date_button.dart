import 'package:flutter/material.dart';

/// RDS Button for showing the date or period. The action usually invoke
/// another widget for selecting a widget or period.
class DateButton extends StatelessWidget {
  final String dateText;
  final double? iconSize;
  final TextStyle? textStyle;
  final Function()? action;
  final Icon? icon;

  const DateButton({
    Key? key,
    required this.dateText,
    this.action,
    this.textStyle,
    this.icon,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton.icon(
      icon: icon ?? Icon(Icons.calendar_today_outlined, size: iconSize),
      label: Text(dateText),
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          textStyle: textStyle ?? Theme.of(context).textTheme.bodyMedium,
          minimumSize: Size(40, 20)),
      onPressed: action);
}
