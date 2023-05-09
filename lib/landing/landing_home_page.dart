import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/appbar/web/landing_page_web_header.dart';
import 'package:groundvisual_flutter/landing/body/tablet/landing_page_body.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/timeline/daily/bloc/daily_timeline_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'appbar/bloc/selected_site_bloc.dart';
import 'appbar/mobile/landing_page_mobile_header.dart';
import 'appbar/tablet/landing_page_tablet_header.dart';
import 'body/mobile/landing_page_body.dart';
import 'chart/bloc/daily/daily_working_time_chart_bloc.dart';
import 'chart/bloc/trend/trend_working_time_chart_bloc.dart';
import 'digest/bloc/play/play_digest_bloc.dart';
import 'machine/bloc/machine_status_bloc.dart';
import 'map/bloc/work_zone_bloc.dart';
import 'map/bloc/work_zone_map_viewmodel.dart';

/// It orchestrates the creation of the Blocs used for widgets on this page
class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LandingHomePageBlocComponent component =
        getIt<LandingHomePageBlocComponent>();

    var selectedSiteBloc = BlocProvider.of<SelectedSiteBloc>(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider<MachineStatusBloc>(
              create: (_) => component.getMachineStatusBloc(selectedSiteBloc)),
          BlocProvider<WorkZoneBloc>(
              create: (_) => component.getWorkZoneMapBloc(selectedSiteBloc)),
          BlocProvider<DailyWorkingTimeChartBloc>(
              create: (_) =>
                  component.getDailyWorkingTimeChartBloc(selectedSiteBloc)),
          BlocProvider<TrendWorkingTimeChartBloc>(
              create: (_) =>
                  component.getTrendWorkingTimeChartBloc(selectedSiteBloc)),
          BlocProvider<PlayDigestBloc>(
              create: (_) => component.getPlayDigestBloc(selectedSiteBloc)),
          BlocProvider<DailyTimelineBloc>(
              create: (_) => component.getDailyTimelineBloc(selectedSiteBloc)),
        ],
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => CustomScrollView(
            slivers: <Widget>[
              LandingHomePageMobileHeader(),
              LandingHomePageMobileBody()
            ],
          ),
          tablet: (BuildContext context) => Scaffold(
            appBar: buildLandingHomePageTabletHeader(context),
            body: LandingHomePageTabletBody(),
          ),
          desktop: (BuildContext context) => Scaffold(
            appBar: buildLandingHomePageWebHeader(context),
            body: LandingHomePageTabletBody(),
          ),
        ));
  }
}

/// Mimic the scoped component in Dagger. There is only one instance of the bloc
/// in the component
@injectable
class LandingHomePageBlocComponent {
  // ignore: close_sinks
  MachineStatusBloc? _machineStatusBloc;

  // ignore: close_sinks
  WorkZoneBloc? _workZoneMapBloc;

  // ignore: close_sinks
  TrendWorkingTimeChartBloc? _trendWorkingTimeChartBloc;

  // ignore: close_sinks
  DailyWorkingTimeChartBloc? _dailyWorkingTimeChartBloc;

  // ignore: close_sinks
  PlayDigestBloc? _playDigestBloc;

  // ignore: close_sinks
  DailyTimelineBloc? _dailyTimelineBloc;

  MachineStatusBloc getMachineStatusBloc(SelectedSiteBloc selectedSiteBloc) {
    final bloc = _machineStatusBloc;
    if (bloc == null) {
      final newBloc = getIt<MachineStatusBloc>(param1: selectedSiteBloc);
      _machineStatusBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }

  PlayDigestBloc getPlayDigestBloc(SelectedSiteBloc selectedSiteBloc) {
    final bloc = _playDigestBloc;
    if (bloc == null) {
      final newBloc = getIt<PlayDigestBloc>(param1: selectedSiteBloc);
      _playDigestBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }

  DailyWorkingTimeChartBloc getDailyWorkingTimeChartBloc(
      SelectedSiteBloc selectedSiteBloc) {
    final bloc = _dailyWorkingTimeChartBloc;
    if (bloc == null) {
      final newBloc = getIt<DailyWorkingTimeChartBloc>(
          param1: selectedSiteBloc,
          param2: getPlayDigestBloc((selectedSiteBloc)));
      _dailyWorkingTimeChartBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }

  TrendWorkingTimeChartBloc getTrendWorkingTimeChartBloc(
      SelectedSiteBloc selectedSiteBloc) {
    final bloc = _trendWorkingTimeChartBloc;
    if (bloc == null) {
      final newBloc =
          getIt<TrendWorkingTimeChartBloc>(param1: selectedSiteBloc);
      _trendWorkingTimeChartBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }

  WorkZoneBloc getWorkZoneMapBloc(SelectedSiteBloc selectedSiteBloc) {
    final bloc = _workZoneMapBloc;
    if (bloc == null) {
      final newBloc = WorkZoneBloc(
          getIt<WorkZoneMapViewModel>(), getIt<DailyChartBarConverter>(),
          selectedSiteBloc: selectedSiteBloc,
          dailyWorkingTimeChartBloc:
              getDailyWorkingTimeChartBloc(selectedSiteBloc),
          trendWorkingTimeChartBloc:
              getTrendWorkingTimeChartBloc(selectedSiteBloc));
      _workZoneMapBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }

  DailyTimelineBloc getDailyTimelineBloc(SelectedSiteBloc selectedSiteBloc) {
    final bloc = _dailyTimelineBloc;
    if (bloc == null) {
      final newBloc = getIt<DailyTimelineBloc>(param1: selectedSiteBloc);
      _dailyTimelineBloc = newBloc;
      return newBloc;
    }
    return bloc;
  }
}
