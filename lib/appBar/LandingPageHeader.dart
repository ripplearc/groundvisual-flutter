import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/appBar/SiteDropDownList.dart';

import 'SliverAppBarTitle.dart';

class LandingPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBarTitle(
      shouldStayWhenCollapse: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.amber,
              width: 100,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 40.0,
            // width: 100,
            child: SiteDropDownList(),
          ),
          Container(
            height: 35.0,
            width: 100.0,
            color: Colors.green,
            child: Switch(
              value: true,
            ),
          )
        ],
      ),
    );
  }
}
