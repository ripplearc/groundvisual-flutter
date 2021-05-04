import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/app/mobile/root_home_mobile_page.dart';
import 'package:groundvisual_flutter/app/tablet/root_home_tablet_page.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_detail.dart';
import 'package:responsive_builder/responsive_builder.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ScreenTypeLayout.builder(
          mobile: (_) => RootHomeMobilePage(),
          tablet: (_) => RootHomeTabletPage());
    });

var timelineDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      final args = context?.settings?.arguments as HeroType;
      return DailyTimelineDetail(heroType: args);
    });
