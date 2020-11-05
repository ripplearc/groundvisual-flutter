import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/appBar/LandingPageHeader.dart';
import 'package:groundvisual_flutter/appBar/SiteDropDownList.dart';
import 'package:groundvisual_flutter/appBar/SliverAppBarTitle.dart';
import 'package:groundvisual_flutter/repositories/CurrentSelectedSite.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'appBar/AppBarTitleContent.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await StreamingSharedPreferences.instance;
  CurrentSelectedSite currentSelectedSite =
      CurrentSelectedSiteImpl(preferences);
  return runApp(Provider(
    create: (_) => currentSelectedSite,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Visual',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

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
