import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/repositories/CurrentSelectedSite.dart';
import 'package:provider/provider.dart';

class AppBarTitleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedSite = Provider.of<CurrentSelectedSite>(context);
    return StreamBuilder<String>(
      stream: selectedSite.site(),
      builder: (context, site) {
        if (site.hasData && site.data.isNotEmpty)
          return Text(site.data,
              style: TextStyle(color: Theme.of(context).colorScheme.primary));
        else
          return Text("");
      },
    );
  }
}
