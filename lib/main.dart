import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/SiteDropDownList.dart';
import 'package:groundvisual_flutter/SliverAppBarTitle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
                child: Text("Kengsinton",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)), shouldStayWhenCollapse: true),
            pinned: true,
            expandedHeight: 150,
            excludeHeaderSemantics: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              // centerTitle: true,
              titlePadding: EdgeInsets.symmetric(horizontal: 20),
              title: SliverAppBarTitle(
                child: SiteDropDownList(),
                shouldStayWhenCollapse: false,
              ),
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
