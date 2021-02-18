import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/document/document_home_page_body.dart';
import 'package:groundvisual_flutter/landing/appbar/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/appbar/landing_page_header.dart';
import 'package:groundvisual_flutter/landing/body/landing_page_body.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/daily_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/chart/bloc/trend_working_time_chart_bloc.dart';
import 'package:groundvisual_flutter/landing/digest/bloc/play_digest_bloc.dart';
import 'package:groundvisual_flutter/landing/machine/bloc/machine_status_bloc.dart';
import 'package:groundvisual_flutter/landing/map/bloc/work_zone_map_bloc.dart';

class DocumentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
            getIt<SelectedSiteBloc>()..add(SelectedSiteInit(context))),
        BlocProvider(create: (_) => getIt<DailyWorkingTimeChartBloc>()),
        BlocProvider(create: (_) => getIt<TrendWorkingTimeChartBloc>()),
        BlocProvider(create: (_) => getIt<MachineStatusBloc>()),
        BlocProvider(create: (_) => getIt<WorkZoneMapBloc>()),
        BlocProvider(create: (_) => getIt<PlayDigestBloc>())
      ],
      child: CustomScrollView(
        slivers: <Widget>[LandingHomePageHeader(), DocumentHomePageBody()],
      ));
}
