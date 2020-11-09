import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/repositories/CurrentSelectedSite.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'GroundVisualApp.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await StreamingSharedPreferences.instance;
  CurrentSelectedSite currentSelectedSite =
      CurrentSelectedSiteImpl(preferences);
  return runApp(Provider(
    create: (_) => currentSelectedSite,
    child: GroundVisualApp(),
  ));
}
