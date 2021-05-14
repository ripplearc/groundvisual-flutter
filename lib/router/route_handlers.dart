import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/app/mobile/root_home_mobile_page.dart';
import 'package:groundvisual_flutter/app/tablet/root_home_tablet_page.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/bloc/timeline_gallery_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/gallery/mobile/timeline_gallery_mobile_view.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/widgets/timeline_search_page.dart';
import 'package:groundvisual_flutter/models/timeline_image_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return ScreenTypeLayout.builder(
      mobile: (_) => RootHomeMobilePage(), tablet: (_) => RootHomeTabletPage());
});

var timelineSearchHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? siteName = params["sitename"]?.first;
  DateTime? date = int.tryParse(params["millisecondssinceepoch"]?.first ?? "")
      ?.let((epoch) => DateTime.fromMillisecondsSinceEpoch(epoch));
  int? initialImageIndex =
      int.tryParse(params["initialImageIndex"]?.first ?? "0");
  if (siteName == null || date == null || initialImageIndex == null)
    return null;

  return BlocProvider(
    create: (context) =>
        getIt<TimelineSearchBloc>()..add(SearchDailyTimeline(siteName, date)),
    child: TimelineSearchPage(initialImageIndex: initialImageIndex),
  );
});

var timelineGalleryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  final args = context?.settings?.arguments as List<TimelineImageModel>;
  int initialIndex = int.tryParse(params["initialIndex"]?.first ?? "0") ?? 0;
  return BlocProvider(
    create: (context) => getIt<TimelineGalleryBloc>(param1: args),
    child: TimelineGalleryMobileView(initialIndex: initialIndex),
  );
});
