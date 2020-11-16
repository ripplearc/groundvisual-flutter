import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DaySelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlatButton.icon(
        height: 20,
        icon: Icon(
          Icons.add_alarm,
          size: 16,
        ),
        label: Text(
          'Today',
          style: Theme.of(context).textTheme.caption,
        ),
        textColor: Theme.of(context).textTheme.caption.color,
        padding: EdgeInsets.all(0),
        color: null,
        onPressed: () {
          // BlocProvider.of<SelectedSiteBloc>(context)
          //     .add(DaySelected(DateTime.now()));
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: 500,
                  color: Theme.of(context).colorScheme.primaryVariant,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CalendarPage(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: null,
                              child: const Text('Confirm'),
                              height: 20,
                            ),
                            FlatButton(
                              onPressed: null,
                              child: const Text('Cancel'),
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      );
}

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
  }

  @override
  Widget build(BuildContext context) {
    return _buildTableCalendar();
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: null,
      holidays: null,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).colorScheme.primary,
        todayColor: Theme.of(context).colorScheme.secondary,
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  }
}
