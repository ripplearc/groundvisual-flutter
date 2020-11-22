import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/appBar/landing_page_header.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/landing_page_body.dart';
import 'package:groundvisual_flutter/route/bottom_navigation.dart';

class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => getIt<SelectedSiteBloc>(),
            child: CustomScrollView(
              slivers: <Widget>[LandingPageHeader(), LandingPageBody()],
            )),
        bottomNavigationBar: BottomNavigation(action: () {
          tappedMenuButton(context, 'native');
        }));
  }
}

class Application {
  static FluroRouter router;
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
    // router.define(demoSimpleFixedTrans,
    //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    // router.define(demoFunc, handler: demoFunctionHandler);
    // router.define(deepLink, handler: deepLinkHandler);
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
    return Material(
      color: color,
      child: Column(
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

// actions
void tappedMenuButton(BuildContext context, String key) {
  String message = "";
  String hexCode = "#FFFFFF";
  String result;
  TransitionType transitionType = TransitionType.native;
  if (key != "custom" && key != "function-call" && key != "fixed-trans") {
    if (key == "native") {
      hexCode = "#F76F00";
      message =
          "This screen should have appeared using the default flutter animation for the current OS";
    } else if (key == "preset-from-left") {
      hexCode = "#5BF700";
      message =
          "This screen should have appeared with a slide in from left transition";
      transitionType = TransitionType.inFromLeft;
    } else if (key == "preset-fade") {
      hexCode = "#F700D2";
      message = "This screen should have appeared with a fade in transition";
      transitionType = TransitionType.fadeIn;
    } else if (key == "pop-result") {
      transitionType = TransitionType.native;
      hexCode = "#7d41f4";
      message =
          "When you close this screen you should see the current day of the week";
      result = ""; //"""Today is ${_daysOfWeek[DateTime.now().weekday - 1]}!";
    }

    String route = "/demo?message=$message&color_hex=$hexCode";

    if (result != null) {
      route = "$route&result=$result";
    }

    Application.router
        .navigateTo(context, route, transition: transitionType)
        .then((result) {
      if (key == "pop-result") {
        Application.router.navigateTo(context, "/demo/func?message=$result");
      }
    });
  } else if (key == "custom") {
    hexCode = "#DFF700";
    message = "This screen should have appeared with a crazy custom transition";
    var transition = (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return ScaleTransition(
        scale: animation,
        child: RotationTransition(
          turns: animation,
          child: child,
        ),
      );
    };
    Application.router.navigateTo(
      context,
      "/demo?message=$message&color_hex=$hexCode",
      transition: TransitionType.custom,
      transitionBuilder: transition,
      transitionDuration: const Duration(milliseconds: 600),
    );
  } else if (key == "fixed-trans") {
    Application.router.navigateTo(
        context, "/demo/fixedtrans?message=Hello!&color_hex=#f4424b");
  } else {
    message = "You tapped the function button!";
    Application.router.navigateTo(context, "/demo/func?message=$message");
  }
}
