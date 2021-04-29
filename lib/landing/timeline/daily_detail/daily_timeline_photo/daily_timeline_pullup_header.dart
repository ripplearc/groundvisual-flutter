import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// The header section of the timeline pullup sheet.
class DailyTimelinePullUpHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).size.width.let((width) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Divider(
                thickness: 4,
                indent: width * 0.43,
                endIndent: width * 0.43,
              ),
              Text(
                "M51",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "April 21st 2021",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(
                thickness: 1,
                indent: width * 0.05,
                endIndent: width * 0.05,
              )
            ],
          ));
}
