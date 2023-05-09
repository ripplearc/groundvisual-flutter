import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_period_sheet.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/trend_period_selection_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'date_selection_button.dart';

class DayOrTrendSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _buildSelectionButton();

  Widget _buildSelectionButton() =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDate) {
          return ScreenTypeLayout.builder(
            mobile: (_) => _buildSelectionButtonForMobile(
                context, state.date, null, state.siteName),
            tablet: (_) => DateSelectionButton(),
            desktop: (_) => DateSelectionButton(),
          );
        } else if (state is SelectedSiteAtTrend) {
          return ScreenTypeLayout.builder(
            mobile: (_) => _buildSelectionButtonForMobile(
                context, null, state.period, state.siteName),
            tablet: (_) => TrendPeriodSelectionButton(),
            desktop: (_) => TrendPeriodSelectionButton(),
          );
        } else {
          return Container();
        }
      });

  Widget _buildSelectionButtonForMobile(
          BuildContext context,
          DateTime? initialSelectedDate,
          TrendPeriod? initialPeriod,
          String siteName) =>
      DateButton(
        iconSize: 12,
        textStyle: Theme.of(context).textTheme.bodySmall,
        dateText: _getButtonText(initialPeriod, initialSelectedDate),
        action: () async {
          final range = await _showBottomSheet(
              context, initialSelectedDate, initialPeriod, siteName);
          range?.let((it) => _onDateSelected(it, context));
        },
      );

  String _getButtonText(
      TrendPeriod? initialPeriod, DateTime? initialSelectedDate) {
    return initialPeriod?.value() ??
        initialSelectedDate?.toShortString() ??
        Date.today.toShortString();
  }

  Future<DateTimeRange?> _showBottomSheet(
          BuildContext scaffoldContext,
          DateTime? initialSelectedDate,
          TrendPeriod? initialPeriod,
          String siteName) =>
      showModalBottomSheet<DateTimeRange>(
          context: scaffoldContext,
          isScrollControlled: true,
          backgroundColor: Theme.of(scaffoldContext).cardTheme.color,
          builder: (_) => _buildCalenderInBottomSheet(
              initialSelectedDate, initialPeriod, siteName));

  Widget _buildCalenderInBottomSheet(
    DateTime? initialSelectedDate,
    TrendPeriod? initialPeriod,
    String title,
  ) =>
      CalendarPeriodSheet(
          initialSelectedDate: initialSelectedDate,
          initialPeriod: initialPeriod,
          title: title);

  void _onDateSelected(DateTimeRange t, BuildContext context) {
    if (t.start.isSameDay(t.end))
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(DateSelected(t.start, context));
    else
      BlocProvider.of<SelectedSiteBloc>(context)
          .add(TrendSelected(t.trendPeriod, context));
  }
}
