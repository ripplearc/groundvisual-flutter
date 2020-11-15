import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';

class TrendLengthSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlatButton.icon(
        height: 20,
        icon: Icon(
          Icons.add_alarm,
          size: 16,
        ),
        label: Text(
          'Last 7 days',
          style: TextStyle(fontSize: 12),
        ),
        textColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.all(0),
        color: null,
        onPressed: () {
          BlocProvider.of<SelectedSiteBloc>(context)
              .add(TrendSelected(LengthOfTrendAnalysis.oneWeek));
        },
      );
}
