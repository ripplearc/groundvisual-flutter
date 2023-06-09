import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/component/selection/date_or_trend_selection_button.dart';
import 'package:groundvisual_flutter/landing/appbar/component/site/site_dropdown_list.dart';

import 'sliver_appbar_container.dart';

class SliverAppBarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverAppBarContainer(
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
            Padding(padding: EdgeInsets.all(2.0)),
            Container(
              height: 30,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30.0,
                      width: 115.0,
                      child: SiteDropDownList(),
                    ),
                    DayOrTrendSelectionButton()
                  ]),
            ),
          ],
        ),
      );
}
