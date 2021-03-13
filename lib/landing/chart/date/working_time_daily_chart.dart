import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_palette.dart';
import 'package:groundvisual_flutter/landing/chart/component/bar_rod_measurement.dart';
import 'package:groundvisual_flutter/landing/chart/component/chart_section_with_title.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'component/working_time_daily_bar_chart.dart';
import 'component/working_time_daily_chart_thumbnail.dart';

/// Widget displays the working and idling time at a date.
/// It can display as a card or embedded in the map card.

class WorkingTimeDailyChart extends StatelessWidget {
  final double aspectRatio;
  final Widget embeddedBackground;
  final Widget thumbnail;
  final bool showTitle;

  const WorkingTimeDailyChart(
      {Key key,
      @required this.aspectRatio,
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
                  children: [
                    _buildBackground(),
                    Positioned.fill(
                        child: WorkingTimeDailyBarChart(
                            barChartDataAtDate: state
                                .transformBarChart(
                                    BarRodPalette(context).colorBarRod)
                                .transformBarChart(
                                    getIt<DailyBarRodMeasurement>(
                                            param1:
                                                _totalWidthOfBarRods(context))
                                        .setBarWidth))),
                    _buildThumbnail()
                  ],
                )
              : Container()));

  double _totalWidthOfBarRods(BuildContext context) =>
      getValueForScreenType<double>(
        context: context,
        mobile: 200,
        tablet: 400,
        desktop: 600,
      );

  Widget _buildBackground() => embeddedBackground != null
      ? Positioned.fill(child: embeddedBackground)
      : Container();

  Widget _buildThumbnail() => thumbnail != null
      ? Positioned.fill(
          child: Align(
          alignment: Alignment.topRight,
          child: WorkingTimeDailyChartThumbnail(),
        ))
      : Container();
}
