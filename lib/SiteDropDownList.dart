import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/repositories/CurrentSelectedSite.dart';
import 'package:provider/provider.dart';

class SiteDropDownList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedSite = Provider.of<CurrentSelectedSiteImpl>(context);
    return StreamBuilder<String>(
      stream: selectedSite.site(),
      builder: (context, site) {
        return DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          isExpanded: false,
          itemHeight: kToolbarHeight,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 20),
          underline: Container(),
          value: site.data,
          onChanged: (String newValue) {
            selectedSite.setSelectedSite(newValue);
          },
          items: <String>['M51', 'Cresent Blvd', 'Kensington']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}
