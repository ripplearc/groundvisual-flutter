import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/bloc/selected_site_bloc.dart';

class SliverAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedSiteBloc, SelectedSiteState>(
        builder: (context, state) {
          if (state is SelectedSiteEmpty) {
            return Text("");
          } else if (state is SelectedSiteAtDate) {
            return Text(state.siteName,
                style: Theme.of(context).textTheme.headline6);
          } else {
            return Text("");
          }
        },
      );
}
