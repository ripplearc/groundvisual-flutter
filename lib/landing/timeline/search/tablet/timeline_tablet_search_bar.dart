import 'dart:ui';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/component/card/time_range_card.dart';
import 'package:groundvisual_flutter/component/dialog/dialog_config.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/search_filter_button.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_filter.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';

/// [TimelineTabletSearchBar] displays and edits the date, date range and time range
/// of the search query. Both tablet and web page use [TimelineTabletSearchBar].
class TimelineTabletSearchBar extends StatelessWidget with WebDialogConfig {
  final Size barSize;
  final EdgeInsets? barMargin;
  final bool? displayBackButton;

  const TimelineTabletSearchBar(
      {Key? key, required this.barSize, this.barMargin, this.displayBackButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
        builder: (blocContext, state) => Container(
            width: barSize.width,
            height: barSize.height,
            margin: barMargin,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0.5, 0.5), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: IntrinsicHeight(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (displayBackButton == true)
                      IconButton(
                          color: Theme.of(context).colorScheme.onBackground,
                          icon: Icon(Icons.arrow_back_outlined),
                          onPressed: () => Navigator.pop(context)),
                    if (displayBackButton == true) SizedBox(width: 20),
                    Text(state.siteName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                VerticalDivider(thickness: 2),
                _buildDateEditButton(context, state),
                VerticalDivider(thickness: 2),
                _buildTimeEditButton(context, state),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VerticalDivider(thickness: 2),
                    SizedBox(width: 5),
                    SearchFilterButton(
                        filterIndicator: state.filterIndicator,
                        onTapFilter: () async {
                          _updateFilteredResults(state, context);
                        })
                  ],
                )
              ],
            ))),
      );

  Widget _buildTimeEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      DateButton(
          textStyle: Theme.of(context).textTheme.bodyText2,
          dateText: state.timeString,
          icon: Icon(Icons.timer, size: 20),
          action: state.enableTimeEdit
              ? () async {
                  DateTimeRange? range = await showDialog<DateTimeRange>(
                      context: context,
                      builder: (_) => SimpleDialog(children: [
                            Container(
                                width: webDialogWidth,
                                height: webDialogHeight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TimeRangeCard(
                                    title: state.siteName,
                                    initialDateTimeRange: state.dateTimeRange,
                                    timeRangeEdited: state.timeRangeEdited))
                          ]));

                  range?.let((it) {
                    BlocProvider.of<TimelineSearchQueryBloc>(context)
                        .add(UpdateTimelineSearchQueryOfTimeRange(it));
                  });
                }
              : null);

  Widget _buildDateEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      DateButton(
          textStyle: Theme.of(context).textTheme.bodyText2,
          dateText: state.dateString,
          action: () async {
            final range = await showDialog<DateTimeRange>(
                context: context,
                builder: (_) => _buildCalenderInDialog(
                    state.dateTimeRange, state.siteName));
            range?.let((it) {
              BlocProvider.of<TimelineSearchQueryBloc>(context)
                  .add(UpdateTimelineSearchQueryOfDateRange(it));
            });
          });

  Widget _buildCalenderInDialog(
          DateTimeRange initialSelectedDateRange, String title) =>
      SimpleDialog(children: [
        Container(
            width: webDialogWidth,
            height: webDialogHeight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CalendarSheet(
              title: title,
              initialSelectedDate: initialSelectedDateRange.start
                      .isSameDay(initialSelectedDateRange.end)
                  ? initialSelectedDateRange.start
                  : Date.today,
              initialSelectedDateRange: initialSelectedDateRange.start
                      .isSameDay(initialSelectedDateRange.end)
                  ? null
                  : initialSelectedDateRange,
              allowRangeSelection: true,
            ))
      ]);

  Future<void> _updateFilteredResults(
      TimelineSearchQueryState state, BuildContext context) async {
    final filteredMachines = await showDialog<Map<MachineDetail, bool>>(
        context: context,
        builder: (_) => SimpleDialog(children: [
              Container(
                width: webDialogWidth,
                  height: webDialogHeight,
                  child: TimelineSearchFilter(
                title: state.siteName,
                subtitle: state.dateTimeString,
                filteredMachines: Map.from(state.filteredMachines),
              ))
            ]));
    filteredMachines?.let((machines) {
      BlocProvider.of<TimelineSearchQueryBloc>(context)
          .add(UpdateTimelineSearchQueryOfSelectedMachines(machines));
    });
  }
}
