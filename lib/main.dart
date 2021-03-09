// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'app/ground_visual_app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  return runApp(GroundVisualApp());
}
