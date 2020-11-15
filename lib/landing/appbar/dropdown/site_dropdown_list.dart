import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';

class SiteDropDownList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
      builder: (blocContext, state) {
        final siteList = <String>['M51', 'Cresent Blvd', 'Kensington'];
        String siteName = 'M51';
        if (state is SelectedSiteAtDay && state.siteName.isNotEmpty) {
          siteName = state.siteName;
        } else if (state is SelectedSiteAtWindow && state.siteName.isNotEmpty) {
          siteName = state.siteName;
        } else {
          BlocProvider.of<SelectedSiteBloc>(context)
              .add(SiteSelected(siteName));
        }
        return DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          itemHeight: kToolbarHeight,
          style: TextStyle(
              color: Theme.of(blocContext).colorScheme.primary, fontSize: 20),
          underline: Container(),
          value: siteName,
          onChanged: (String newValue) {
            BlocProvider.of<SelectedSiteBloc>(context)
                .add(SiteSelected(newValue));
          },
          items: siteList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
