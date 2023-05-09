import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/buttons/cancel_button.dart';
import 'package:groundvisual_flutter/component/buttons/confirm_button.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';

/// [TimelineSearchFilter] refines the search query to certain machines being selected.
/// It returns the new filtered machine in the pop result.
class TimelineSearchFilter extends StatefulWidget {
  final String title;
  final String subtitle;
  final Map<MachineDetail, bool> filteredMachines;

  const TimelineSearchFilter(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.filteredMachines})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimelineSearchFilterState();
}

class TimelineSearchFilterState extends State<TimelineSearchFilter> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              )),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text(widget.subtitle,
                  style: Theme.of(context).textTheme.titleMedium)),
          Divider(thickness: 2),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Equipments",
                  style: Theme.of(context).textTheme.titleLarge)),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.filteredMachines.keys.length,
                  itemBuilder: (_, index) => CheckboxListTile(
                        title: Text(widget.filteredMachines.keys
                            .elementAt(index)
                            .modelYear),
                        value: widget.filteredMachines.values.elementAt(index),
                        activeColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onChanged: (bool? value) {
                          setState(() {
                            final key =
                                widget.filteredMachines.keys.elementAt(index);
                            widget.filteredMachines[key] = value ?? false;
                          });
                        },
                      ))),
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
                  confirmAction: () {
                    Navigator.of(context).pop(widget.filteredMachines);
                  }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: CancelButton(cancelAction: () {
                Navigator.pop(context);
              }),
            ),
          )
        ],
      );
}
