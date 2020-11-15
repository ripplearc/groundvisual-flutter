import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/selection/day_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/selection/trend_length_selection_button.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';

class DayOrTrendSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
        if (state is SelectedSiteAtDay) {
          return DaySelectionButton();
        } else {
          return TrendLengthSelectionButton();
        }
      });
}
