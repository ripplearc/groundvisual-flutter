import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function() cancelAction;

  const CancelButton({Key key, this.cancelAction}) : super(key: key);

  @override
  Widget build(BuildContext context) => ButtonTheme(
        minWidth: 160.0,
        height: 40.0,
        child: OutlineButton(
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: cancelAction),
      );
}
