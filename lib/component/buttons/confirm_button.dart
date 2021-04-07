import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// RDS confirm button for executing an action.
class ConfirmButton extends StatelessWidget {
  final Function()? confirmAction;

  const ConfirmButton({Key? key, this.confirmAction}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: confirmAction,
        child: Text('Confirm'),
        style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.background,
            backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: Size(160, 40),
            textStyle: Theme.of(context).textTheme.subtitle1),
      );
}
