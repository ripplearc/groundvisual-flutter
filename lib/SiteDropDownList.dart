import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SiteDropDownList extends StatefulWidget {
  SiteDropDownList({Key key}) : super(key: key);

  @override
  _SiteDropDownListState createState() {
    // TODO: implement createState
    return _SiteDropDownListState();
  }
}

class _SiteDropDownListState extends State<SiteDropDownList> {
  String _dropdownValue = 'Kensington';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      isExpanded: false,
      itemHeight: kToolbarHeight,
      style:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
        });
      },
      items: <String>['M51', 'Cresent Blvd', 'Kensington']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
