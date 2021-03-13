import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// RDS Button for showing the date or period. The action usually invoke
/// another widget for selecting a widget or period.
class DateButton extends StatelessWidget {
  final String dateText;
  final Function() action;

  const DateButton({Key key, this.dateText, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton.icon(
      icon: Icon(Icons.calendar_today_outlined, size: 12),
      label: Text(dateText),
      style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.primary,
          textStyle: Theme.of(context).textTheme.caption,
          minimumSize: Size(40, 20)),
      onPressed: action);
}
