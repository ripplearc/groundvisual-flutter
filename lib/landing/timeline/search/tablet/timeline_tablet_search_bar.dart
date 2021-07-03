import 'package:charts_flutter/flutter.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/component/buttons/date_button.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

class TimelineTabletSearchBar extends StatelessWidget {
  final Size barSize;
  final EdgeInsets? barMargin;

  const TimelineTabletSearchBar(
      {Key? key, required this.barSize, this.barMargin})
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 6,
                    child: Text(state.siteName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1)),
                VerticalDivider(thickness: 2),
                _buildDateEditButton(context, state),
                VerticalDivider(thickness: 2),
                _buildTimeEditButton(context, state),
              ],
            ))),
      );

  Widget _buildTimeEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      DateButton(
          textStyle: Theme.of(context).textTheme.bodyText2,
          dateText: state.timeString,
          icon: Icon(Icons.timer, size: 20),
          action: state.enableTimeEdit ? () async {} : null);

  Widget _buildDateEditButton(
          BuildContext context, TimelineSearchQueryState state) =>
      DateButton(
          textStyle: Theme.of(context).textTheme.bodyText2,
          dateText: state.dateString,
          action: () async {
            final range = await showDialog<DateTimeRange>(
                context: context,
                // isScrollControlled: true,
                // backgroundColor: Theme.of(context).cardTheme.color,
                builder: (_) => _buildCalenderInBottomSheet(
                    state.dateTimeRange, state.siteName));
            range?.let((it) {
              BlocProvider.of<TimelineSearchQueryBloc>(context)
                  .add(UpdateTimelineSearchQueryOfDateRange(it));
            });
          });

  Widget _buildCalenderInBottomSheet(
          DateTimeRange initialSelectedDateRange, String title) =>
      SimpleDialog(children: [
        Container(
          width: 600,
          height: 700,
          child: CalendarSheet(
            title: title,
            initialSelectedDate: Date.today,
            initialSelectedDateRange: null,
            allowRangeSelection: true,
          ),
        )
      ]);
}
