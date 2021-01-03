import 'package:flutter/material.dart';

Widget genChartSectionWithTitle(
        BuildContext context, Widget content, bool compacted) =>
    compacted
        ? _genChartSectionWithTitleInCompactMode(context, content)
        : _genChartSectionWithTitleInNormalMode(context, content);

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
      title: Text('Working Time', style: Theme.of(context).textTheme.headline5),
    );
