import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/sliver/sliver_appbar_body.dart';
import 'package:groundvisual_flutter/landing/appbar/sliver/sliver_appbar_container.dart';
import 'package:groundvisual_flutter/landing/appbar/title/sliver_appbar_title.dart';


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
