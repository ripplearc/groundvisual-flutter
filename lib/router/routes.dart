import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/app/mobile/root_home_mobile_page.dart';
import 'package:groundvisual_flutter/app/tablet/root_home_tablet_page.dart';
import 'package:groundvisual_flutter/router/placeholder_navigation_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
    return ScreenTypeLayout.builder(
        mobile: (_) => RootHomeMobilePage(),
        tablet: (_) => RootHomeTabletPage());
  });

  static var _placeholderRouteHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String message = params["message"]?.first;
    return PlaceholderWidget(message);
  });
}
