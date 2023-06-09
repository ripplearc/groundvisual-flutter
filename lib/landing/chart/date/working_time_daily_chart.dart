import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_measurement.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_palette.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';

import 'component/working_time_daily_bar_chart.dart';

/// Widget displays the working and idling time at a date.
/// It can display as a card or embedded in the map card.

class WorkingTimeDailyChart extends StatelessWidget {
  final double aspectRatio;
  final Widget? embeddedBackground;
  final Widget? thumbnail;
  final bool showTitle;

  const WorkingTimeDailyChart(
      {Key? key,
      required this.aspectRatio,
      this.embeddedBackground,
      this.thumbnail,
      this.showTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => showTitle
      ? chartSectionWithTitleBuilder(
          context: context,
          builder: _buildChartContent(context),
          compacted: false)
      : _buildChartContent(context);

  Widget _buildChartContent(BuildContext context) => AspectRatio(
        aspectRatio: aspectRatio,
        child: _buildBarChartCard(context),
      );

  Widget _buildBarChartCard(BuildContext context) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      color: embeddedBackground != null
          ? Colors.transparent
          : Theme.of(context).colorScheme.background,
      child: BlocBuilder<DailyWorkingTimeChartBloc, DailyWorkingTimeState>(
          buildWhen: (previous, current) =>
              current is DailyWorkingTimeDataLoaded,
          builder: (context, state) => state is DailyWorkingTimeDataLoaded
              ? Stack(
                  children: [_buildBackground(), _buildForeground(state)],
                )
              : Container()));

  Positioned _buildForeground(DailyWorkingTimeDataLoaded state) =>
      Positioned.fill(
          child: LayoutBuilder(
              builder: (context, constraints) => getIt<DailyBarRodMeasurement>(
                      param1: constraints.biggest.width)
                  .let((ruler) => WorkingTimeDailyBarChart(
                      ruler: ruler,
                      barChartDataAtDate: state
                          .transformBarRod(BarRodPalette(context).colorBarRod)
                          .transformBarRod(ruler.setBarWidth)
                          .transformBarGroup(ruler.setBarSpace)))));

  Widget _buildBackground() =>
      embeddedBackground?.let((embedded) => Positioned.fill(child: embedded)) ??
      Container();
}
