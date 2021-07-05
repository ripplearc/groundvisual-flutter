import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/component/card/time_range_card.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/search_filter_button.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_visual_search_bar.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';

/// [TimelineEditSearchBar] allows edit of the date and time in the search query.
/// It transits to the visual mode after [onExitEditMode], or transitions to the
/// filter mode after [onTapFilter].
/// See also [TimelineVisualSearchBar].
class TimelineEditSearchBar extends StatelessWidget {
  final GestureTapCallback? onExitEditMode;
  final GestureTapCallback? onTapFilter;
  final String? filterIndicator;

  const TimelineEditSearchBar(
      {Key? key, this.onExitEditMode, this.onTapFilter, this.filterIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
          builder: (blocContext, state) =>
              _buildAppBarEditModeContent(context, state));

  Column _buildAppBarEditModeContent(
          BuildContext context, TimelineSearchQueryState state) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchModeHeader(context),
          _buildSearchModeBody(context, state)
        ],
      );

  Container _buildSearchModeHeader(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            _buildExitSearchModeButton(context),
            Expanded(
                child: Center(
                    child: Text("Edit your search",
                        style: Theme.of(context).textTheme.headline6))),
            SearchFilterButton(
                filterIndicator: filterIndicator, onTapFilter: onTapFilter)
          ],
        ),
      );

  IconButton _buildExitSearchModeButton(BuildContext context) => IconButton(
        onPressed: onExitEditMode,
        icon: Icon(Icons.close),
        color: Theme.of(context).colorScheme.onBackground,
      );

  Container _buildSearchModeBody(
          BuildContext context, TimelineSearchQueryState state) =>
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
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
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: IntrinsicHeight(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDateEditButton(context, state),
              VerticalDivider(thickness: 2),
              _buildTimeEditButton(context, state),
            ],
          )));

  Expanded _buildTimeEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      Expanded(
          child: DateButton(
              textStyle: Theme.of(context).textTheme.bodyText2,
              dateText: state.timeString,
              icon: Icon(Icons.timer, size: 20),
              action: state.enableTimeEdit
                  ? () async {
                      DateTimeRange? range =
                          await showModalBottomSheet<DateTimeRange>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor:
                                  Theme.of(context).cardTheme.color,
                              builder: (_) => TimeRangeCard(
                                  title: state.siteName,
                                  initialDateTimeRange: state.dateTimeRange,
                                  timeRangeEdited: state.timeRangeEdited));

                      range?.let((it) {
                        BlocProvider.of<TimelineSearchQueryBloc>(context)
                            .add(UpdateTimelineSearchQueryOfTimeRange(it));
                        _updateWorkZoneMapAndExit(context, state.siteName, it,
                            state.filteredMachines);
                      });
                    }
                  : null));

  Expanded _buildDateEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      Expanded(
          child: DateButton(
              textStyle: Theme.of(context).textTheme.bodyText2,
              dateText: state.dateString,
              action: () async {
                final range = await showModalBottomSheet<DateTimeRange>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).cardTheme.color,
                    builder: (_) => _buildCalenderInBottomSheet(
                        state.dateTimeRange, state.siteName));
                range?.let((it) {
                  BlocProvider.of<TimelineSearchQueryBloc>(context)
                      .add(UpdateTimelineSearchQueryOfDateRange(it));
                  _updateWorkZoneMapAndExit(
                      context, state.siteName, it, state.filteredMachines);
                });
              }));

  void _updateWorkZoneMapAndExit(BuildContext context, String siteName,
      DateTimeRange it, Map<MachineDetail, bool> filteredMachines) {
    BlocProvider.of<WorkZoneBloc>(context).add(SearchWorkZoneAtTime(
        siteName, it.start, it.end,
        filteredMachines: filteredMachines));
    onExitEditMode?.call();
  }

  Widget _buildCalenderInBottomSheet(
          DateTimeRange initialSelectedDateRange, String title) =>
      CalendarSheet(
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
      );
}
