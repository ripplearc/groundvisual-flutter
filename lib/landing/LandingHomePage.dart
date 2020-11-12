import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/di/di.dart';
import 'package:groundvisual_flutter/landing/appBar/LandingPageHeader.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';
import 'package:groundvisual_flutter/landing/body/LandingPageBody.dart';

class LandingHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => getIt<SelectedSiteBloc>(),
            child: CustomScrollView(
              slivers: <Widget>[LandingPageHeader(), LandingPageBody()],
            )));
  }
}
