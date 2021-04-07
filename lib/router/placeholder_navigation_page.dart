import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/router/bottom_navigation.dart';

/// Placeholder for testing the router.
class PlaceholderWidget extends StatelessWidget {
  final String? pageTitle;
  final SelectedTab? tab;

  PlaceholderWidget({this.pageTitle, this.tab});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        tab?.icon().icon ?? Icons.engineering,
                        size: 80,
                      ),
                      Text(
                        pageTitle ?? "",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ))),
        ),
      );
}
