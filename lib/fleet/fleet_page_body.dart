import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/component/card/calendar_sheet.dart';

class FleetHomePage extends StatefulWidget {
  FleetHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FleetHomePageState createState() => _FleetHomePageState();
}

class _FleetHomePageState extends State<FleetHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: ElevatedButton(
              child: Text('Show Calendar Dialog'),
              onPressed: _showMaterialDialog)));

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              backgroundColor: Theme.of(context).cardTheme.color,
              children: [
                _calenderSelection(ctx, Date.startOfToday, (DateTime? t) {})
              ],
            ));
  }

  Widget _calenderSelection(
    BuildContext context,
    DateTime initialSelectedDate,
    Function(DateTime? t) action,
  ) =>
      Container(
        height: 600,
        width: 500,
        child: CalendarSheet(initialSelectedDate: initialSelectedDate),
      );
}
