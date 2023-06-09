import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/router/route_handlers.dart';

/// Register the route address and its destination
class Routes {
  static String root = "/";
  static String timelineSearch = "/site/timeline/search";
  static String timelineGallery = "/site/timeline/gallery";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(timelineSearch, handler: timelineSearchHandler);
    router.define(timelineGallery, handler: timelineGalleryHandler);
  }



}
