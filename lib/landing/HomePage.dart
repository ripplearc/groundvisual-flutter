import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appBar/AppBarTitleContent.dart';
import 'appBar/LandingPageHeader.dart';
import 'appBar/SliverAppBarTitle.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: SliverAppBarTitle(
                child: AppBarTitleContent(), shouldStayWhenCollapse: true),
            pinned: true,
            expandedHeight: 120,
            excludeHeaderSemantics: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.symmetric(horizontal: 20),
              title: LandingPageHeader(),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile(
                title: Text("List tile $index"),
              );
            },
            childCount: 30,
          ))
        ],
      ),
    );
  }
}
