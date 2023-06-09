import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/buttons/cancel_button.dart';
import 'package:groundvisual_flutter/component/buttons/confirm_button.dart';
import 'package:groundvisual_flutter/component/dialog/decorated_dialog.dart';
import 'package:groundvisual_flutter/extensions/date.dart';
import 'package:time_range/time_range.dart';

/// [TimeRangeCard] is the RDS design that returns the selection of the time range at a certain day.
/// The ending time must be later than the starting time.
class TimeRangeCard extends StatefulWidget {
  final DateTimeRange initialDateTimeRange;
  final String? title;
  final bool timeRangeEdited;

  TimeRangeResult? get initialTimeRange => timeRangeEdited
      ? TimeRangeResult(TimeOfDay.fromDateTime(initialDateTimeRange.start),
          TimeOfDay.fromDateTime(initialDateTimeRange.end))
      : TimeRangeResult(
          TimeOfDay(hour: 6, minute: 0), TimeOfDay(hour: 18, minute: 0));

  const TimeRangeCard(
      {Key? key,
      this.title,
      required this.initialDateTimeRange,
      required this.timeRangeEdited})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimeRangeCardState();
}

class TimeRangeCardState extends State<TimeRangeCard> {
  static const double leftPadding = 50;

  TimeRangeResult? _timeRange;

  @override
  void initState() {
    super.initState();
    _timeRange = widget.initialTimeRange;
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 40),
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(widget.title ?? "",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 30),
            child: Text(widget.initialDateTimeRange.start.toShortString(),
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Divider(thickness: 2),
          SizedBox(height: 20),
          TimeRange(
            fromTitle:
                Text('FROM', style: Theme.of(context).textTheme.titleLarge),
            toTitle: Text('TO', style: Theme.of(context).textTheme.titleLarge),
            titlePadding: leftPadding,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            activeTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.apply(color: Theme.of(context).colorScheme.background),
            borderColor: Theme.of(context).colorScheme.onSurface,
            activeBorderColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: Theme.of(context).colorScheme.primary,
            firstTime: TimeOfDay(hour: 0, minute: 00),
            lastTime: TimeOfDay(hour: 24, minute: 00),
            initialRange: _timeRange,
            timeStep: 15,
            timeBlock: 15,
            onRangeCompleted: (range) => setState(() => _timeRange = range),
          ),
          Spacer(),
          Divider(thickness: 2),
          SizedBox(height: 10),
          _buildButtons(),
          SizedBox(height: 30),
        ],
      );

  Row _buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ConfirmButton(
                      text: "Search",
                      confirmAction: () async {
                        final range = _timeRange;
                        if (range != null) {
                          Navigator.of(context).pop(DateTimeRange(
                              start: widget
                                  .initialDateTimeRange.start.startOfDay
                                  .addHours(range.start.hour)
                                  .addMinutes(range.start.minute),
                              end: widget.initialDateTimeRange.start.startOfDay
                                  .addHours(range.end.hour)
                                  .addMinutes(range.end.minute)));
                        } else {
                          await showDialog(
                              context: context,
                              builder: (ctx) => DecoratedDialog(
                                  title: "Invalid Time",
                                  descriptions:
                                      "Missing ending time selection"));
                        }
                      }))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CancelButton(cancelAction: () {
                    Navigator.pop(context);
                  })))
        ],
      );
}
