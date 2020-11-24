import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/app/root_home_page.dart';
import 'package:groundvisual_flutter/route/placeholder_navigation_page.dart';

/// Register the route address and its destination
class Routes {
  static String root = "/";
  static String siteDetail = "/site/detail";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: _rootHandler);
    router.define(siteDetail, handler: _placeholderRouteHandler);
  }

  static var _rootHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return RootHomePage();
  });

  static var _placeholderRouteHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String message = params["message"]?.first;
    return PlaceholderWidget(message);
  });
}
