import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';

class LandingPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(
              title: ListElement(index: index),
              tileColor: Theme.of(context).colorScheme.background,
              onTap: () {
                tappedMenuButton(context, getIt<FluroRouter>(), 'native');
              },
            );
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

// actions
void tappedMenuButton(BuildContext context, FluroRouter router, String key) {
  String message = "";
  String hexCode = "#FFFFFF";
  String result;
  TransitionType transitionType = TransitionType.native;
  if (key != "custom" && key != "function-call" && key != "fixed-trans") {
    if (key == "native") {
      hexCode = "#F76F00";
      message =
      "This screen should have appeared using the default flutter animation for the current OS";
      transitionType = TransitionType.inFromRight;
    }
    String route = "/demo?message=$message&color_hex=$hexCode";

    if (result != null) {
      route = "$route&result=$result";
    }

    router
        .navigateTo(context, route, transition: transitionType)
        .then((result) {
      if (key == "pop-result") {
        router.navigateTo(context, "/demo/func?message=$result");
      }
    });
  } else {
    message = "You tapped the function button!";
    router.navigateTo(context, "/demo/func?message=$message");
  }
}
