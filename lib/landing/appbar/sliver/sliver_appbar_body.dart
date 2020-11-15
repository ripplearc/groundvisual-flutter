import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/selection/day_or_trend_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/toggle/day_trend_toggle.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';

import '../dropdown/site_dropdown_list.dart';
import 'sliver_appbar_container.dart';

class SliverAppBarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
          builder: (context, state) => SliverAppBarContainer(
                shouldStayWhenCollapse: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      height: 40.0,
                      width: 130.0,
                      child: SiteDropDownList(),
                    ),
                    Padding(padding: EdgeInsets.all(2.0)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DayTrendToggle(),
                          Expanded(child: Container(width: double.infinity)),
                          Container(
                              height: 20, child: DayOrTrendSelectionButton())
                        ]),
                    Padding(padding: EdgeInsets.all(4.0)),
                  ],
                ),
              ));
}
