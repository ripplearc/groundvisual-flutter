import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/app/mobile/root_home_mobile_page.dart';
import 'package:groundvisual_flutter/app/tablet/root_home_tablet_page.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/bloc/daily_timeline_detail_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/daily_detail/daily_timeline_photo/daily_timeline_detail.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return ScreenTypeLayout.builder(
      mobile: (_) => RootHomeMobilePage(), tablet: (_) => RootHomeTabletPage());
});

var timelineDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? siteName = params["sitename"]?.first;
  DateTime? date = int.tryParse(params["millisecondssinceepoch"]?.first ?? "")
      ?.let((epoch) => DateTime.fromMillisecondsSinceEpoch(epoch));
  int? initialImageIndex =
      int.tryParse(params["initialImageIndex"]?.first ?? "");
  if (siteName == null || date == null || initialImageIndex == null)
    return null;

  return BlocProvider(
    create: (context) =>
        getIt<TimelineSearchBloc>()..add(SearchDailyTimeline(siteName, date)),
    child: DailyTimelineDetail(initialImageIndex: initialImageIndex),
  );
});
