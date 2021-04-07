import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// RDS cancel button for dismissing a widget without executing a cancel
/// action. E.g. dismissing a alert dialog or bottom sheet.
class CancelButton extends StatelessWidget {
  final Function()? cancelAction;

  const CancelButton({Key? key, this.cancelAction}) : super(key: key);

  @override
  Widget build(BuildContext context) => ButtonTheme(
        minWidth: 160.0,
        height: 40.0,
        child: OutlinedButton(
            child: Text(
              'Cancel',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.apply(color: Theme.of(context).colorScheme.primary),
            ),
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary)),
            onPressed: cancelAction),
      );
}
