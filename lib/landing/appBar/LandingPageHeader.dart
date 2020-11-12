import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SliverAppBarTitle.dart';
import 'SliverAppBarBody.dart';
import 'SliverAppBarContainer.dart';

class LandingPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
     SliverAppBar(
      title: SliverAppBarContainer(
          child: SliverAppBarTitle(), shouldStayWhenCollapse: true),
      pinned: true,
      expandedHeight: 120,
      excludeHeaderSemantics: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: EdgeInsets.symmetric(horizontal: 20),
        title: SliverAppBarBody(),
      ),
    );
}
