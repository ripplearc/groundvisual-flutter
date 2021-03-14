import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/body/tablet/landing_page_body.dart';
import 'package:injectable/injectable.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'appbar/bloc/selected_site_bloc.dart';
import 'appbar/mobile/landing_page_mobile_header.dart';
import 'body/mobile/landing_page_body.dart';
import 'chart/bloc/daily_working_time_chart_bloc.dart';
import 'chart/bloc/trend_working_time_chart_bloc.dart';
import 'digest/bloc/play_digest_bloc.dart';
import 'machine/bloc/machine_status_bloc.dart';
import 'map/bloc/work_zone_map_bloc.dart';
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
          BlocProvider<WorkZoneMapBloc>(
              create: (_) => component.getWorkZoneMapBloc(selectedSiteBloc)),
          BlocProvider<DailyWorkingTimeChartBloc>(
              create: (_) =>
                  component.getDailyWorkingTimeChartBloc(selectedSiteBloc)),
          BlocProvider<TrendWorkingTimeChartBloc>(
              create: (_) =>
                  component.getTrendWorkingTimeChartBloc(selectedSiteBloc)),
          BlocProvider<PlayDigestBloc>(
              create: (_) => component.getPlayDigestBloc(selectedSiteBloc)),
        ],
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => CustomScrollView(
            slivers: <Widget>[
              LandingHomePageMobileHeader(),
              LandingHomePageMobileBody()
            ],
          ),
          tablet: (BuildContext context) => LandingHomePageTabletBody(),
          desktop: (BuildContext context) => LandingHomePageTabletBody(),
        ));
  }
}

/// Mimic the scoped component in Dagger. There is only one instance of the bloc
/// in the component
@injectable
class LandingHomePageBlocComponent {
  // ignore: close_sinks
  MachineStatusBloc _machineStatusBloc;

  // ignore: close_sinks
  WorkZoneMapBloc _workZoneMapBloc;

  // ignore: close_sinks
  TrendWorkingTimeChartBloc _trendWorkingTimeChartBloc;

  // ignore: close_sinks
  DailyWorkingTimeChartBloc _dailyWorkingTimeChartBloc;

  // ignore: close_sinks
  PlayDigestBloc _playDigestBloc;

  MachineStatusBloc getMachineStatusBloc(SelectedSiteBloc selectedSiteBloc) {
    if (_machineStatusBloc == null) {
      _machineStatusBloc = getIt<MachineStatusBloc>(param1: selectedSiteBloc);
    }
    return _machineStatusBloc;
  }

  PlayDigestBloc getPlayDigestBloc(SelectedSiteBloc selectedSiteBloc) {
    if (_playDigestBloc == null) {
      _playDigestBloc = getIt<PlayDigestBloc>(param1: selectedSiteBloc);
    }
    return _playDigestBloc;
  }

  DailyWorkingTimeChartBloc getDailyWorkingTimeChartBloc(
      SelectedSiteBloc selectedSiteBloc) {
    if (_dailyWorkingTimeChartBloc == null) {
      this._dailyWorkingTimeChartBloc = getIt<DailyWorkingTimeChartBloc>(
          param1: selectedSiteBloc,
          param2: getPlayDigestBloc((selectedSiteBloc)));
    }
    return _dailyWorkingTimeChartBloc;
  }

  TrendWorkingTimeChartBloc getTrendWorkingTimeChartBloc(
      SelectedSiteBloc selectedSiteBloc) {
    if (_trendWorkingTimeChartBloc == null) {
      this._trendWorkingTimeChartBloc =
          getIt<TrendWorkingTimeChartBloc>(param1: selectedSiteBloc);
    }
    return _trendWorkingTimeChartBloc;
  }

  WorkZoneMapBloc getWorkZoneMapBloc(SelectedSiteBloc selectedSiteBloc) {
    if (_workZoneMapBloc == null) {
      this._workZoneMapBloc = WorkZoneMapBloc(getIt<WorkZoneMapViewModel>(),
          selectedSiteBloc: selectedSiteBloc,
          dailyWorkingTimeChartBloc:
              getDailyWorkingTimeChartBloc(selectedSiteBloc),
          trendWorkingTimeChartBloc:
              getTrendWorkingTimeChartBloc(selectedSiteBloc));
    }
    return _workZoneMapBloc;
  }
}
