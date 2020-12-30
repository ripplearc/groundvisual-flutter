import 'package:flutter/material.dart';

Stack genChartSectionWithTitle(BuildContext context, Widget content) => Stack(
      children: [
        content,
        ListTile(
          title: Text('Working Time',
              style: Theme.of(context).textTheme.headline5),
        ),
      ],
    );
