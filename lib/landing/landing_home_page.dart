import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/appBar/landing_page_header.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/landing_page_body.dart';
import 'package:groundvisual_flutter/route/bottom_navigation.dart';

class LandingHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingHomePageState();
}

class _LandingHomePageState extends State<LandingHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    BlocProvider(
        create: (_) => getIt<SelectedSiteBloc>(),
        child: CustomScrollView(
          slivers: <Widget>[LandingPageHeader(), LandingPageBody()],
        )),
    PlaceholderWidget(Colors.white, "Fleet Page Under Construction"),
    PlaceholderWidget(Colors.deepOrange, "Document Page Under Construction"),
    PlaceholderWidget(Colors.green, "Account Page Under Construction")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigation(action: (index) {
          setState(() {
            _currentIndex = index;
          });
        }));
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String pageTitle;

  PlaceholderWidget(this.color, this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(pageTitle, style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}

class Routes {
  static String root = "/";
  static String demoSimple = "/demo";
  static String demoSimpleFixedTrans = "/demo/fixedtrans";
  static String demoFunc = "/demo/func";
  static String deepLink = "/message";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(demoSimple, handler: demoRouteHandler);
  }
}

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LandingHomePage();
});

var demoRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String message = params["message"]?.first;
  String colorHex = params["color_hex"]?.first;
  String result = params["result"]?.first;
  Color color = Color(0xFFFFFFFF);
  if (colorHex != null && colorHex.length > 0) {
    color = Colors.orange;
  }
  return DemoSimpleComponent(message: message, color: color, result: result);
});

class DemoSimpleComponent extends StatelessWidget {
  DemoSimpleComponent(
      {String message = "Testing",
      Color color = const Color(0xFFFFFFFF),
      String result})
      : this.message = message,
        this.color = color,
        this.result = result;

  final String message;
  final Color color;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's go back"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/images/acc_boom.png"),
            color: Colors.white,
            width: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                height: 2.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 42.0),
              child: FlatButton(
                highlightColor: Colors.yellow,
                splashColor: Colors.pink,
                onPressed: () {
                  if (result == null) {
                    /// You can use [Navigator.pop]
                    Navigator.pop(context);
                  } else {
                    /// Or [FluroRouter.pop]
                    FluroRouter.appRouter.pop(context, result);
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
