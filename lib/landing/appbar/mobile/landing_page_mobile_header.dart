import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/appbar/mobile/sliver/sliver_appbar_body.dart';
import 'package:groundvisual_flutter/landing/appbar/mobile/sliver/sliver_appbar_container.dart';
import 'package:groundvisual_flutter/landing/appbar/mobile/title/sliver_appbar_title.dart';


class LandingHomePageMobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
     SliverAppBar(
      title: SliverAppBarContainer(
          child: SliverAppBarTitle(), shouldStayWhenCollapse: true),
      pinned: true,
      expandedHeight: 70,
      excludeHeaderSemantics: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: EdgeInsets.symmetric(horizontal: 20),
        title: SliverAppBarBody(),
      ),
    );
}
