import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/component/buttons/confirm_button.dart';

/// DecoratedDialog allows specification of icon at the header of the Dialog.
class DecoratedDialog extends StatelessWidget {
  final String title, descriptions;

  final IconData icon;
  final double avatarRadius = 60;
  final double padding = 20;

  const DecoratedDialog(
      {Key? key,
      required this.title,
      required this.descriptions,
      this.icon = Icons.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildContentBox(context),
      );

  _buildContentBox(context) => Stack(children: [
        Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.onBackground,
                      offset: Offset(3, 3),
                      blurRadius: 3)
                ]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 20),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.apply(fontWeightDelta: 2)),
              SizedBox(height: 15),
              Text(
                descriptions,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfirmButton(
                      text: "OK",
                      confirmAction: () {
                        Navigator.pop(context);
                      })),
            ])),
        Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: avatarRadius,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(avatarRadius)),
                    child: Icon(
                      icon,
                      size: avatarRadius,
                      color: Theme.of(context).colorScheme.primary,
                    ))))
      ]);
}
