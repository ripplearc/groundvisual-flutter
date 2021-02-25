import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/document/document_home_page_body.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/landing_page_header.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';
import 'package:groundvisual_flutter/repositories/current_selected_site.dart';
import 'package:injectable/injectable.dart';

@injectable
class DocumentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DocumentHomePageBlocComponent component =
        getIt<DocumentHomePageBlocComponent>();
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
          slivers: <Widget>[LandingHomePageHeader(), DocumentHomePageBody()],
        ));
  }
}

@injectable
class DocumentHomePageBlocComponent {
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

  DocumentHomePageBlocComponent(this.machineStatusBloc, this.workZoneMapBloc) {
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
