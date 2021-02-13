import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'app/ground_visual_app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  return GroundVisualApp();
  // return runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => GroundVisualApp(),
    // ),
  // );
}
