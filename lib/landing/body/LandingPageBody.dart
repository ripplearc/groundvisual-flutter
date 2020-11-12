import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(
              title: Text("List tile $index"),
            );
          },
          childCount: 30,
        ),
      );
}
