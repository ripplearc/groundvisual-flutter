import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/component/card/time_range_card.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_bar.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// [TimelineMobileSearchBar] specifies the date, time range of the
/// search query. It transitions between visual and search edit mode.
/// The visual mode display the current search query while the search
/// edit mode allows edit of the query.
class TimelineMobileSearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimelineMobileSearchBarState();
}

class TimelineMobileSearchBarState extends State<TimelineMobileSearchBar> {
  Widget? _animatedAppBar;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation =
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, -0.0))
                  .animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: _animatedAppBar ?? _buildAppBarInVisualMode(),
      );

  AppBar _buildAppBarInVisualMode() => AppBar(
        key: ValueKey(1),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
            builder: (blocContext, state) => TimelineSearchBar(
                dateString: state.dateString,
                siteName: state.siteName,
                onTap: () => setState(() {
                      _animatedAppBar = _buildAppBarInSearchMode();
                    }))),
      );

  AppBar _buildAppBarInSearchMode() => AppBar(
      key: ValueKey(2),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 30),
          child: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
              builder: (blocContext, state) =>
                  _buildAppBarSearchModeContent(state))));

  Column _buildAppBarSearchModeContent(TimelineSearchQueryState state) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildSearchModeHeader(), _buildSearchModeBody(state)],
      );

  Container _buildSearchModeBody(TimelineSearchQueryState state) => Container(
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
          _buildDateEditButton(state),
          VerticalDivider(thickness: 2),
          _buildTimeEditButton(state),
        ],
      )));

  Expanded _buildTimeEditButton(TimelineSearchQueryState state) => Expanded(
      child: DateButton(
          textStyle: Theme.of(context).textTheme.bodyText2,
          dateText: state.timeString,
          icon: Icon(Icons.calendar_today_outlined, size: 20),
          action: state.enableTimeEdit
              ? () async {
                  DateTimeRange? range =
                      await showModalBottomSheet<DateTimeRange>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).cardTheme.color,
                          builder: (_) => _buildTimeRangeBottomSheet(
                              state.siteName,
                              state.dateTimeRange.start,
                              state.dateTimeRange.end));

                  range?.let((it) =>
                      BlocProvider.of<TimelineSearchQueryBloc>(context)
                          .add(UpdateTimelineSearchQueryOfDateTimeRange(it)));
                }
              : null));

  Expanded _buildDateEditButton(TimelineSearchQueryState state) => Expanded(
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
            range?.let((it) => BlocProvider.of<TimelineSearchQueryBloc>(context)
                .add(UpdateTimelineSearchQueryOfDateTimeRange(it)));
          }));

  Container _buildTimeRangeBottomSheet(
          String title, DateTime start, DateTime end) =>
      Container(
          height: 380,
          child: TimeRangeCard(
              title: title,
              initialDateTimeRange: (DateTimeRange(start: start, end: end))));

  Container _buildCalenderInBottomSheet(
          DateTimeRange initialSelectedDateRange, String title) =>
      Container(
        height: 560,
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
        ),
      );

  Container _buildSearchModeHeader() => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            _buildExitSearchModeButton(),
            Expanded(
                child: Center(
                    child: Text("Edit your search",
                        style: Theme.of(context).textTheme.headline6))),
            _buildSearchFilterButton()
          ],
        ),
      );

  IconButton _buildExitSearchModeButton() => IconButton(
        onPressed: () => setState(() {
          _animatedAppBar = _buildAppBarInVisualMode();
        }),
        icon: Icon(Icons.close),
        color: Theme.of(context).colorScheme.onBackground,
      );

  IconButton _buildSearchFilterButton() => IconButton(
        onPressed: () {},
        icon: Icon(Icons.filter_list),
        color: Theme.of(context).colorScheme.onBackground,
      );
}
