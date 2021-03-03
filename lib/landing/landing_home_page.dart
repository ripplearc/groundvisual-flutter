import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/body/tablet/landing_page_body.dart';
import 'package:groundvisual_flutter/landing/chart/converter/daily_chart_bar_converter.dart';
import 'package:groundvisual_flutter/landing/chart/date/working_time_daily_chart_viewmodel.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:injectable/injectable.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'appbar/bloc/selected_site_bloc.dart';
import 'appbar/mobile/landing_page_mobile_header.dart';
import 'body/phone/landing_page_body.dart';
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<MachineStatusBloc>(
              create: (_) => component.machineStatusBloc),
          BlocProvider<WorkZoneMapBloc>(
              create: (_) => component.workZoneMapBloc),
          BlocProvider<DailyWorkingTimeChartBloc>(
              create: (_) => component.dailyWorkingTimeChartBloc),
          BlocProvider<TrendWorkingTimeChartBloc>(
              create: (_) => component.trendWorkingTimeChartBloc),
          BlocProvider<PlayDigestBloc>(create: (_) => component.playDigestBloc),
          BlocProvider<SelectedSiteBloc>(
              create: (_) =>
                  component.selectedSiteBloc..add(SelectedSiteInit(context))),
        ],
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => CustomScrollView(
            slivers: <Widget>[
              LandingHomePageMobileHeader(),
              LandingHomePageMobileBody()
            ],
          ),
          tablet: (BuildContext context) => LandingHomePageTabletBody(),
          desktop: (BuildContext context) => Container(color: Colors.red),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ));
  }
}

@injectable
class LandingHomePageBlocComponent {
  final MachineStatusBloc machineStatusBloc;

  // ignore: close_sinks
  WorkZoneMapBloc workZoneMapBloc;

  // ignore: close_sinks
  TrendWorkingTimeChartBloc trendWorkingTimeChartBloc;

  // ignore: close_sinks
  DailyWorkingTimeChartBloc dailyWorkingTimeChartBloc;

  // ignore: close_sinks
  PlayDigestBloc playDigestBloc;

  // ignore: close_sinks
  SelectedSiteBloc selectedSiteBloc;

  LandingHomePageBlocComponent(this.machineStatusBloc) {
    this.trendWorkingTimeChartBloc =
        // getIt<TrendWorkingTimeChartBloc>(param1: workZoneMapBloc);
        getIt<TrendWorkingTimeChartBloc>();
    this.selectedSiteBloc = SelectedSiteBloc(
      getIt<CurrentSelectedSite>(),
      machineStatusBloc,
      // dailyWorkingTimeChartBloc,
      trendWorkingTimeChartBloc,
      // playDigestBloc
    );
    this.workZoneMapBloc = WorkZoneMapBloc(getIt<WorkZoneMapViewModel>(),
        selectedSiteBloc: selectedSiteBloc,
        dailyWorkingTimeChartBloc: dailyWorkingTimeChartBloc,
        trendWorkingTimeChartBloc: trendWorkingTimeChartBloc);

    this.dailyWorkingTimeChartBloc
        // getIt<DailyWorkingTimeChartBloc>(param1: selectedSiteBloc);
        = DailyWorkingTimeChartBloc(getIt<DailyChartBarConverter>(),
            getIt<WorkingTimeDailyChartViewModel>(), selectedSiteBloc);
    this.playDigestBloc =
        getIt<PlayDigestBloc>(param1: dailyWorkingTimeChartBloc);
  }
}
