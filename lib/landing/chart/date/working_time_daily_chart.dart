import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'bloc/working_time_chart_touch_bloc.dart';
import 'model/working_time_daily_chart_data.dart';

/// Widget displays the working and idling time on a certain date.
class WorkingTimeDailyChart extends StatelessWidget {
  final WorkingTimeDailyChartData data;

  WorkingTimeDailyChart(this.data);

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) =>
          getIt<WorkingTimeChartTouchBloc>()..add(NoBarRodSelection()),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: Stack(
          children: [_buildBarChartCard(context), _buildThumbnailImage()],
        ),
      ));

  BlocBuilder _buildThumbnailImage() =>
      BlocBuilder<WorkingTimeChartTouchBloc, WorkingTimeChartTouchState>(
        builder: (context, state) => Positioned(
          top: 0.0,
          right: 0.0,
          child: _buildThumbnailImageUponTouch(state),
        ),
      );

  Widget _buildThumbnailImageUponTouch(WorkingTimeChartTouchState state) {
    if (state is WokringTimeChartTouchShowThumbnail) {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            state.assetName,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ));
    } else {
      return Container();
    }
  }

  Positioned _buildBarChartCard(BuildContext context) => Positioned.fill(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 72.0),
            child: _BarChart(data: data),
            // child: Stack(children: [_buildBarChart(context)]),
          ),
        ),
      );
}

class _BarChart extends StatelessWidget {
  final WorkingTimeDailyChartData data;

  const _BarChart({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildBarChart(context);

  BarChart _buildBarChart(BuildContext context) => BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.background,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      data.tooltips[groupIndex][rodIndex]),
              touchCallback: (barTouchResponse) =>
                  triggerBarRodSelectionEventUponTouch(
                    barTouchResponse,
                    context,
                  )),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
              margin: 2,
              getTitles: (double index) => data.bottomTitles[index.toInt()],
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: 15,
              getTextStyles: (value) => Theme.of(context).textTheme.caption,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: 1.8,
          barGroups: data.bars,
        ),
      );

  void triggerBarRodSelectionEventUponTouch(
      BarTouchResponse barTouchResponse, BuildContext context) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      BlocProvider.of<WorkingTimeChartTouchBloc>(context).add(BarRodSelection(
          barTouchResponse.spot.touchedBarGroupIndex,
          barTouchResponse.spot.touchedRodDataIndex));
    }
  }
}
