import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(title: ListElement(index: index),
            tileColor: Theme.of(context).colorScheme.background,);
          },
          childCount: 30,
        ),
      );
}

class ListElement extends StatelessWidget {
  final int index;

  const ListElement({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text("List tile $index");
}
