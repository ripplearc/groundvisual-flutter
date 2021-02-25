import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:injectable/injectable.dart';

import 'appbar/bloc/selected_site_bloc.dart';
import 'appbar/landing_page_header.dart';
import 'body/landing_page_body.dart';
import 'chart/bloc/daily_working_time_chart_bloc.dart';
import 'chart/bloc/trend_working_time_chart_bloc.dart';
import 'digest/bloc/play_digest_bloc.dart';
import 'machine/bloc/machine_status_bloc.dart';
import 'map/bloc/work_zone_map_bloc.dart';

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
              create: (_) => component.selectedSiteBloc..add(SelectedSiteInit(context))),
        ],
        child: CustomScrollView(
          slivers: <Widget>[LandingHomePageHeader(), LandingHomePageBody()],
        ));
  }
}

@injectable
class LandingHomePageBlocComponent {
  final MachineStatusBloc machineStatusBloc;
  final WorkZoneMapBloc workZoneMapBloc;
  // ignore: close_sinks
  TrendWorkingTimeChartBloc trendWorkingTimeChartBloc;
  // ignore: close_sinks
  DailyWorkingTimeChartBloc dailyWorkingTimeChartBloc;
  // ignore: close_sinks
  PlayDigestBloc playDigestBloc;
  // ignore: close_sinks
  SelectedSiteBloc selectedSiteBloc;

  LandingHomePageBlocComponent(this.machineStatusBloc, this.workZoneMapBloc) {
    this.trendWorkingTimeChartBloc =
        getIt<TrendWorkingTimeChartBloc>(param1: workZoneMapBloc);
    this.dailyWorkingTimeChartBloc =
        getIt<DailyWorkingTimeChartBloc>(param1: workZoneMapBloc);
    this.playDigestBloc =
        getIt<PlayDigestBloc>(param1: dailyWorkingTimeChartBloc);
    this.selectedSiteBloc = SelectedSiteBloc(
        getIt<CurrentSelectedSite>(),
        machineStatusBloc,
        workZoneMapBloc,
        dailyWorkingTimeChartBloc,
        trendWorkingTimeChartBloc,
        playDigestBloc);
  }
}
