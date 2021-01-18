import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'appbar/bloc/selected_site_bloc.dart';
import 'appbar/landing_page_header.dart';
import 'body/landing_page_body.dart';
import 'chart/bloc/working_time_chart_touch_bloc.dart';
import 'machine/bloc/machine_status_bloc.dart';
import 'map/bloc/work_zone_map_bloc.dart';

class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) =>
                    getIt<SelectedSiteBloc>()..add(SelectedSiteInit(context))),
            BlocProvider(create: (_) => getIt<WorkingTimeChartTouchBloc>()),
            BlocProvider(create: (_) => getIt<MachineStatusBloc>()),
            BlocProvider(create: (_) => getIt<WorkZoneMapBloc>()),
          ],
          child: CustomScrollView(
            slivers: <Widget>[LandingHomePageHeader(), LandingHomePageBody()],
          ));
}
