import 'package:flutter/material.dart';

Widget chartSectionWithTitleBuilder(
        {required BuildContext context,
        required Widget builder,
        bool compacted = false}) =>
    compacted
        ? _genChartSectionWithTitleInCompactMode(context, builder)
        : _genChartSectionWithTitleInNormalMode(context, builder);

Stack _genChartSectionWithTitleInCompactMode(
        BuildContext context, Widget content) =>
    Stack(
      children: [
        content,
        _genTitle(context),
      ],
    );

Column _genChartSectionWithTitleInNormalMode(
        BuildContext context, Widget content) =>
    Column(
      children: [
        _genTitle(context),
        content,
      ],
    );

ListTile _genTitle(BuildContext context) => ListTile(
      title: Text('Working Time', style: Theme.of(context).textTheme.subtitle1),
    );
