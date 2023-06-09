import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SiteDropDownList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
      builder: (blocContext, state) {
        final siteList = <String>[
          'M51',
          'Cresent Blvd',
          'Kensington',
          'Penton Rise'
        ];
        String siteName = 'M51';
        if (state is SelectedSiteAtDate && state.siteName.isNotEmpty) {
          siteName = state.siteName;
        } else if (state is SelectedSiteAtTrend && state.siteName.isNotEmpty) {
          siteName = state.siteName;
        } else {
          BlocProvider.of<SelectedSiteBloc>(context)
              .add(SiteSelected(siteName, context));
        }
        return DropdownButton<String>(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
          ),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          itemHeight: kToolbarHeight,
          style: getValueForScreenType<TextStyle?>(
              context: context,
              mobile: Theme.of(context).textTheme.titleMedium,
              tablet: Theme.of(context).textTheme.headlineSmall),
          dropdownColor: Theme.of(context).colorScheme.background,
          underline: Container(),
          value: siteName,
          onChanged: (String? newValue) {
            if (newValue != siteName) {
              BlocProvider.of<SelectedSiteBloc>(context)
                  .add(SiteSelected(newValue ?? siteName, context));
            }
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
