import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/selection/date_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/selection/trend_period_selection_button.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site/selected_site_bloc.dart';

class DayOrTrendSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) {
            if (state is SelectedSiteAtDate) {
              return DateSelectionButton();
            } else {
              return TrendPeriodSelectionButton();
            }
          });
}
