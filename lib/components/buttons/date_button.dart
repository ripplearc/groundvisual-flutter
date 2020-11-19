import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  final String dateText;
  final Function() action;

  const DateButton({Key key, this.dateText, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) => FlatButton.icon(
      height: 20,
      icon: Icon(Icons.calendar_today_outlined, size: 12),
      label: Text(
        dateText,
        style: Theme.of(context)
            .textTheme
            .caption
            .apply(color: Theme.of(context).colorScheme.primary),
      ),
      textColor: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.all(0),
      onPressed: action);
}
