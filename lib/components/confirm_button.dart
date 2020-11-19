import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {

  final Function() confirmAction;

  const ConfirmButton({Key key, this.confirmAction}) : super(key: key);
  @override
  Widget build(BuildContext context) => FlatButton(
        onPressed: confirmAction,
        height: 40,
        minWidth: 160,
        color: Theme.of(context).colorScheme.primary,
        child: Text('Confirm',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .apply(color: Theme.of(context).colorScheme.background)),
      );
}
