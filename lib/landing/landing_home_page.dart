import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'appbar/landing_page_header.dart';
import 'bloc/selected_site_bloc.dart';
import 'body/landing_page_body.dart';

class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => getIt<SelectedSiteBloc>(),
      child: CustomScrollView(
        slivers: <Widget>[LandingPageHeader(), LandingPageBody()],
      ));
}
